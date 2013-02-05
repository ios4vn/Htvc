//
//  HTListView.m
//  HTListView
//
//  Created by Hai Trieu on 11/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HTListView.h"
#import "SBJson.h"
#import "ODRefreshControl.h"
#import "SVPullToRefresh.h"
#import "AppDelegate.h"
@interface  HTListView ()

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl;
-(void)setupTableView;

@end

@implementation HTListView

@synthesize tableView = _tableView;
@synthesize footerIndicator = _footerIndicator;
@synthesize itemForShare = _itemForShare;

@synthesize arrayNews = _arrayNews;
@synthesize urlGetNews = _urlGetNews;

AppDelegate *appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_arrayNews == nil) {
        self.arrayNews = [[NSMutableArray alloc] init];
    }
    if (_itemForShare == nil) {
        self.itemForShare = [[NSMutableDictionary alloc] init];
    }
//    
//    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
//    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    [self setupTableView];
    
    pageSize = kPageSize;
    pageNumber = kPageNumber;

    //start from page 0
    keyword = @"";
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrayNews count];
}

-(void)reloadNews:(NSString*)urlAPI{
    
    NSString *urlRequest = [[[NSString alloc] initWithFormat:@"%@&pagenumber=%d&pagesize=%d&keyword=%@&token=%@",urlAPI,pageNumber,pageSize,keyword,SharedAppDelegate.token] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"url request %@",urlRequest);
    
    NSURL *url = [NSURL URLWithString: urlRequest];
    __block ASIHTTPRequest *requestNews = [ASIHTTPRequest requestWithURL:url];
    [requestNews setCompletionBlock:^{
        [_tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
        if ([[requestNews responseString] length] > 2) {
            [self processResponse:[requestNews responseString]];
        }
        else{
            [self.arrayNews removeAllObjects];
            [self.tableView reloadData];
        }
    }];
    [requestNews setFailedBlock:^{
        [_tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
    }];
    [requestNews startAsynchronous];
    
}

-(void)updateTableView:(NSArray *)tmpNews{
    if (pageNumber == 0) {
        [self.arrayNews removeAllObjects];
    }
    
    for (NSDictionary *dict in tmpNews) {
        [self.arrayNews addObject:dict];
    }
    
    if (pageNumber == 0) {
        
        [[self tableView] reloadData];
        
    }
    else{
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        
        for (NSInteger i=pageNumber*pageSize; i < pageNumber*pageSize + [tmpNews count]; i++) {
            
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }        
        [[self tableView] beginUpdates];
        [[self tableView] insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [indexPaths release];                
        
        [[self tableView] endUpdates];
        NSLog(@"finish insert row at index here");         
    }
}

-(void)processResponse:(NSString*)responseString{
    
    NSArray *tmpNews = [responseString JSONValue];
    
    [self updateTableView:tmpNews];

}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    pageNumber = 0;
    keyword = @"";
//    self.tableView.showsInfiniteScrolling = YES;
    
    [self reloadNews:self.urlGetNews];

    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
    });
}

-(void)setupTableView{
    // setup the pull-to-refresh view
    [self.tableView addPullToRefreshWithActionHandler:^{
        pageNumber = 0;
        [self reloadNews:self.urlGetNews];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yy H:mm"];
        _tableView.pullToRefreshView.dateFormatter = dateFormatter;
        _tableView.pullToRefreshView.lastUpdatedDate = [NSDate date];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        pageNumber++;
        [self reloadNews:self.urlGetNews];
    }];
}

#pragma mark FBDialogDelegate

#pragma end FBDialogDelegate

#pragma mark FBSessionDelegate

- (void)fbDidLogin {
    [self shareViaFacebook];
}

- (void)fbDidNotLogin:(BOOL)cancelled{
    
}

- (void)fbSessionInvalidated{
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception"
                              message:@"Your session has expired."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    [alertView release];
}

- (void)fbDidLogout {
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt{
    NSLog(@"token extended");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

#pragma end FBSessionDelegate


-(void)shareViaFacebook{
    if (![[appDelegate facebook] isSessionValid]) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"offline_access",@"email",@"publish_actions", nil];
        
        appDelegate.delegate = self;
        [[appDelegate facebook] authorize:permissions];
    }
    else{
        SBJsonWriter *jsonWriter = [[SBJsonWriter new] autorelease];
        
        // The action links to be shown with the post in the feed
        NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          @"Check out this item on Life4u",@"name",@"http://m.life4u.vn",@"link", nil], nil];
        NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
        // Dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Hội mọi thứ đều chính chủ", @"name",
                                       @"Chính chủ cho IOS.", @"caption",
                                       [self.itemForShare objectForKey:@"title"], @"description",
                                       [self.itemForShare objectForKey:@"img"], @"link",
                                       [self.itemForShare objectForKey:@"img"], @"picture",
                                       actionLinksStr, @"actions",
                                       nil];
        
        [[appDelegate facebook] dialog:@"feed"
                             andParams:params
                           andDelegate:self];
    }
    
}


-(void)showWithAnimated:(UIView*)showView withAnimated:(float)duration{
    
    showView.frame = CGRectMake(0,self.view.frame.size.height, showView.frame.size.width, showView.frame.size.height);
    CGRect tmpRect = showView.frame;
    
    tmpRect.origin.y = self.navigationController.view.frame.size.height - showView.frame.size.height;
    
    [self.navigationController.view addSubview:showView];
    
	[ self.navigationController.view bringSubviewToFront:showView ];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    showView.frame = tmpRect;
    
    [UIView commitAnimations];
}

-(void)hideWithAnimated:(UIView*)hideView withAnimated:(float)duration{
    CGRect tmpRect = hideView.frame;
    tmpRect.origin.y = self.view.frame.size.height;
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:hideView];
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    
    hideView.frame = tmpRect;
    [UIView commitAnimations];
}

@end

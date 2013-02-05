//
//  HistoryViewController.m
//  MobileCoupon
//
//  Created by Hai Trieu on 1/9/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "HistoryViewController.h"
#import "SVPullToRefresh.h"

@implementation HistoryViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Lịch sử";
    self.navigationItem.leftBarButtonItem = nil;
    
    self.urlGetNews = [NSString stringWithFormat:@"%@/coupon_api.php?act=history",kDomain];
    
    [self reloadNews:self.urlGetNews];
    self.tableView.showsInfiniteScrolling = NO;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HistoryTableViewCell";
    
    NSDictionary *item = [self.arrayNews objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
        {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        }
    
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [item objectForKey:@"name"];
    cell.detailTextLabel.text = [item objectForKey:@"purchase_time_format"];
    
    return cell;
}


-(void)processResponse:(NSString*)responseString{
    
    NSArray *tmpNews = [[responseString JSONValue] objectForKey:@"history"];
    
    NSLog(@"tmp news count %d",[tmpNews count]);
    [self updateTableView:tmpNews];
    
}

@end

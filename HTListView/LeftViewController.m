//
//  LeftViewController.m
//  ViewDeckExample
//


#import "LeftViewController.h"
#import "IIViewDeckController.h"
#import "ViewController.h"
#import "SVPullToRefresh.h"
#import "ChanelListViewController.h"
#import "InfoViewController.h"
#import "SideCell.h"
#import "SBJson.h"

@implementation LeftViewController

@synthesize footer;
@synthesize header;

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
    
    self.tableView.scrollsToTop = NO;

    self.tableView.tableFooterView = footer;
    self.tableView.tableHeaderView = header;
    
    self.urlGetNews = [NSString stringWithFormat:@"%@api.php?act=getFavorites",kDomain];
    
    [self reloadNews:self.urlGetNews];   
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.arrayNews objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"SideCell";
    
    SideCell *cell = (SideCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
        {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (SideCell*)[nib objectAtIndex:0];
        }
    
    cell.name.text = [item objectForKey:@"name"];
    cell.description.text = [item objectForKey:@"description"];
    cell.thumb.imageURL = [NSURL URLWithString:[item objectForKey:@"logo"]];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        if ([controller.centerController isKindOfClass:[UINavigationController class]]) {
                self.viewDeckController.centerController = SharedAppDelegate.navController;
                [SharedAppDelegate.navController popToRootViewControllerAnimated:NO];

                ViewController* cc = (ViewController*)SharedAppDelegate.navController.topViewController;
                NSDictionary *item = [self.arrayNews objectAtIndex:indexPath.row];
                [cc chanelSelected:item];
                if ([cc respondsToSelector:@selector(tableView)]) {
                    [cc.tableView deselectRowAtIndexPath:[cc.tableView indexPathForSelectedRow] animated:NO];    
            }
        }
        [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0];
    }];
}


-(void)processResponse:(NSString*)responseString{
    
    NSArray *tmpNews = [[responseString JSONValue] objectForKey:@"favorites"];
    
    [self updateTableView:tmpNews];
    
}

-(IBAction)chanelClick:(id)sender{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        if (SharedAppDelegate.chanelController == nil) {
            SharedAppDelegate.chanelController = [[UINavigationController alloc] initWithRootViewController:[[ChanelListViewController alloc] initWithNibName:@"ChanelListViewController" bundle:nil]];
        }
        self.viewDeckController.centerController = SharedAppDelegate.chanelController;
        [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0];
    }];
}

-(IBAction)infoClick:(id)sender{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        if (SharedAppDelegate.infoController == nil) {
            SharedAppDelegate.infoController = [[UINavigationController alloc] initWithRootViewController:[[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil]];
        }
        self.viewDeckController.centerController = SharedAppDelegate.infoController;
        [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0];
    }];
}

-(void)reloadSideView{
    [self reloadNews:self.urlGetNews];
}

@end

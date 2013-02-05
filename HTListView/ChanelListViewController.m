//
//  ChanelListViewController.m
//  HTVC
//
//  Created by Hai Trieu on 1/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ChanelListViewController.h"
#import "IIViewDeckController.h"
#import "LeftViewController.h"
#import "SVPullToRefresh.h"
#import "ChanelListCell.h"
#import "ChanelDetailViewController.h"

@implementation ChanelListViewController

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
    
    self.title = @"Danh sách kênh";
    self.tableView.showsInfiniteScrolling = NO;
    
    self.urlGetNews = [NSString stringWithFormat:@"%@api.php?act=getChannelSections",kDomain];

    [self reloadNews:self.urlGetNews];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.arrayNews count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[self.arrayNews objectAtIndex:section] objectForKey:@"channels"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return headerSection.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *sectionView  = [[UIView alloc] initWithFrame:headerSection.frame];
    UILabel *sectionName = [[UILabel alloc] initWithFrame:nameSection.frame];
    sectionView.backgroundColor = headerSection.backgroundColor;
    sectionName.font = nameSection.font;
    sectionName.backgroundColor = [UIColor clearColor];
    sectionName.textColor = [UIColor whiteColor];
    [sectionView addSubview:sectionName];
    sectionName.text = [[self.arrayNews objectAtIndex:section] objectForKey:@"section_name"];
    
    return sectionView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChanelListCell";
    
    NSDictionary *item = [[[self.arrayNews objectAtIndex:indexPath.section] objectForKey:@"channels"] objectAtIndex:indexPath.row];
    
    ChanelListCell *cell = (ChanelListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
        {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (ChanelListCell*)[nib objectAtIndex:0];
        }
    cell.thumb.imageURL = [NSURL URLWithString:[item objectForKey:@"logo"]];
    cell.name.text = [item objectForKey:@"name"];
    cell.description.text = [item objectForKey:@"description"];
    cell.like.tag = [[item objectForKey:@"id"] intValue];
    if ([[item objectForKey:@"is_favorite"] intValue] == 0) {
        [cell.like setImage:[UIImage imageNamed:@"Button_Like.png"] forState:UIControlStateNormal];
    }
    else{
        [cell.like setImage:[UIImage imageNamed:@"Button_DisLike.png"] forState:UIControlStateNormal];
    }
    [cell.like addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *item = [[[self.arrayNews objectAtIndex:indexPath.section] objectForKey:@"channels"] objectAtIndex:indexPath.row];
    ChanelDetailViewController *chanelDetail = [[[ChanelDetailViewController alloc] initWithNibName:@"ChanelDetailViewController" bundle:nil andChanel:item] autorelease];
    [self.navigationController pushViewController:chanelDetail animated:YES];
    
}
-(void)processResponse:(NSString*)responseString{
    
    NSArray *tmpNews = [[responseString JSONValue] objectForKey:@"sections"];
    
    [self updateTableView:tmpNews];
}

-(void)likeBtnClick:(id)sender{
    UIButton *like = (UIButton*)sender;
    int chanelId = like.tag;
    NSString *urlSetAction;
    if ([UIImage imageNamed:@"Button_Like.png"] == [like imageForState:UIControlStateNormal]) {
        urlSetAction = [NSString stringWithFormat:@"http://smsviet.vn/tvguide/api.php?act=addToFavorite&channel_id=%d&token=%@",chanelId,SharedAppDelegate.token];
        [like setImage:[UIImage imageNamed:@"Button_DisLike.png"] forState:UIControlStateNormal];
    }
    else{
        urlSetAction = [NSString stringWithFormat:@"http://smsviet.vn/tvguide/api.php?act=removeFromFavorite&channel_id=%d&token=%@",chanelId,SharedAppDelegate.token];
        [like setImage:[UIImage imageNamed:@"Button_Like.png"] forState:UIControlStateNormal];
    }

    ASIHTTPRequest *setAction  = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlSetAction]];
    [setAction startAsynchronous];
    LeftViewController *leftView = (LeftViewController*)self.viewDeckController.leftController;
    [leftView reloadSideView];
}

@end

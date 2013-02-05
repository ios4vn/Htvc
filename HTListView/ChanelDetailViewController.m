//
//  ChanelDetailViewController.m
//  HTVC
//
//  Created by Hai Trieu on 1/28/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ChanelDetailViewController.h"
#import "IIViewDeckController.h"
#import "LeftViewController.h"
#import "ChanelDetailCell.h"
#import "SVPullToRefresh.h"
#import "OLGhostAlertView.h"

@implementation ChanelDetailViewController

@synthesize header;
@synthesize dateConvert;
@synthesize dateConvertReverse;
@synthesize times = _times;
@synthesize thumb = _thumb;
@synthesize name = _name;
@synthesize description = _description;
@synthesize like = _like;
@synthesize unlike = _unlike;
@synthesize database = _database;
@synthesize itemForAlarm = _itemForAlarm;
@synthesize pickerView;
@synthesize date = _date;

#pragma mark - iVars
NSMutableArray *datesArray;
int indexCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andChanel:(NSDictionary*)_chanel
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        chanel = _chanel;
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
    self.title = [chanel objectForKey:@"name"];
    
    self.database = [FMDatabase databaseWithPath:SharedAppDelegate.databasePath];
    [self.database open];
    
    self.tableView.tableHeaderView = header;
    self.name.text = [chanel objectForKey:@"name"];
    self.thumb.imageURL = [NSURL URLWithString:[chanel objectForKey:@"logo"]];
    self.description.text = [chanel objectForKey:@"description"];

    if ([[chanel objectForKey:@"is_favorite"] intValue] == 1) {
        self.unlike.hidden = NO;
        self.like.hidden = YES;
    }
    else{
        self.unlike.hidden = YES;
        self.like.hidden = NO;    
    }
    dateConvert = [[NSDateFormatter alloc] init];
    [dateConvert setDateFormat:@"dd/MM"];
    dateConvertReverse = [[NSDateFormatter alloc] init];
    [dateConvertReverse setDateFormat:@"yyyy-MM-dd"];

    self.tableView.showsInfiniteScrolling = NO;
    
    
    if (_times == nil) {
        self.times = timesBefore;
    }
    
    self.urlGetNews = [NSString stringWithFormat:@"%@api.php?act=getByChannel&id=%@",kDomain,[chanel objectForKey:@"id"]];
    
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChanelDetailCell";
    
    NSDictionary *item = [self.arrayNews objectAtIndex:indexPath.row];
    
    ChanelDetailCell *cell = (ChanelDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (ChanelDetailCell*)[nib objectAtIndex:0];
            
            if([[item objectForKey:@"focus_row"] isEqualToString:@"true"]){
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }

    cell.time.text = [[item objectForKey:@"start_time"] substringWithRange:NSMakeRange(11, 5)];
    cell.name.text = [item objectForKey:@"name"];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showWithAnimated:pkBeforeView withAnimated:0.3];
    self.itemForAlarm = [self.arrayNews objectAtIndex:indexPath.row];
}

#pragma mark
#pragma UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.times count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.times objectAtIndex:row];
}


-(void)processResponse:(NSString*)responseString{
    
    datesArray = [[responseString JSONValue] objectForKey:@"date"];
    
    if (pickerView == nil) {
        CGFloat margin = 40.0f;
        CGFloat width = 240;
        CGFloat pickerHeight = 48.0f;
        CGFloat x = margin;
        CGFloat y = 0;
        CGRect tmpFrame = CGRectMake(x, y, width, pickerHeight);
        
        pickerView = [[V8HorizontalPickerView alloc] initWithFrame:tmpFrame];
        pickerView.backgroundColor   = [UIColor darkGrayColor];
        pickerView.selectedTextColor = [UIColor whiteColor];
        pickerView.textColor   = [UIColor grayColor];
        pickerView.delegate    = self;
        pickerView.dataSource  = self;
        pickerView.elementFont = [UIFont boldSystemFontOfSize:14.0f];
        pickerView.selectionPoint = CGPointMake(120, 0);
        pickerView.backgroundColor = [UIColor clearColor];
        
        //scroll to today
        [pickerView scrollToElement:2 animated:YES];
        
        [header addSubview:pickerView];
    }
    
    NSArray *tmpNews = [[responseString JSONValue] objectForKey:@"programs"];
    
    [self updateTableView:tmpNews];
}

-(IBAction)likeBtnClick:(id)sender{
    int chanelId = [[chanel objectForKey:@"id"] intValue];
    NSString *urlSetLike = [NSString stringWithFormat:@"%@api.php?act=addToFavorite&channel_id=%d&token=%@",kDomain,chanelId,SharedAppDelegate.token];
    ASIHTTPRequest *setLike  = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlSetLike]];
    [setLike startAsynchronous];
    self.like.hidden = YES;
    self.unlike.hidden = NO;
    LeftViewController *leftView = (LeftViewController*)self.viewDeckController.leftController;
    [leftView reloadSideView];
}

-(IBAction)unlikeBtnClick:(id)sender{
    int chanelId = [[chanel objectForKey:@"id"] intValue];
    NSString *urlRemoveLike = [NSString stringWithFormat:@"%@api.php?act=removeFromFavorite&channel_id=%d&token=%@",kDomain,chanelId,SharedAppDelegate.token];
    ASIHTTPRequest *removeLike  = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlRemoveLike]];
    [removeLike startAsynchronous];
    self.like.hidden = NO;
    self.unlike.hidden = YES; 
    LeftViewController *leftView = (LeftViewController*)self.viewDeckController.leftController;
    [leftView reloadSideView];
}

-(IBAction)cancelBtnClick:(id)sender{
    [self hideWithAnimated:pkBeforeView withAnimated:0.3];
}

-(IBAction)setBtnClick:(id)sender{
    [self hideWithAnimated:pkBeforeView withAnimated:0.3];
    int index = [pkBefore selectedRowInComponent:0];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"Y-MM-dd HH:mm:ss"];
    NSDate *startTime = [format dateFromString:[self.itemForAlarm objectForKey:@"start_time"]];
    
    int secondBefore = 0;
    switch (index) {
        case 0:
            //five minutes
            secondBefore = 5*60;
            break;
        case 1:
            //fifteen minutes
            secondBefore = 15*60;
            break;
        case 2:
            //one hour
            secondBefore = 60*60;
            break;
        case 3:
            //one day
            secondBefore = 24*60*60;
            break;
        default:
            break;
    }
    secondBefore = secondBefore * -1;
    
    
    NSDate *timeForAlarm = [NSDate dateWithTimeInterval:secondBefore sinceDate:startTime];
    NSDate *today = [[NSDate alloc] init];
    if ([timeForAlarm compare:today] == NSOrderedAscending) {
        OLGhostAlertView *alertView = [[OLGhostAlertView alloc] initWithTitle:@"Chương trình đã phát. Vui lòng chọn chương trình khác"];
        [alertView show];
        [alertView release];
    }
    else{
        NSString *query = [NSString stringWithFormat:@"INSERT INTO 'main'.'alarms' ('logo','chanel_name','program_name','start_time','before') VALUES ('%@','%@','%@','%@',%d)",[chanel objectForKey:@"logo"],[chanel objectForKey:@"name"],[self.itemForAlarm objectForKey:@"name"],[self.itemForAlarm objectForKey:@"start_time"],index];
        [self.database executeUpdate:query];

        NSDictionary *infoNotification = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",[self.database lastInsertRowId]],@"id", nil];

        
        [[MKLocalNotificationsScheduler sharedInstance] scheduleNotificationOn:timeForAlarm text:[self.itemForAlarm objectForKey:@"name"] action:@"Xem" sound:nil launchImage:nil andInfo:infoNotification];
        
    }
    
}

#pragma mark - HorizontalPickerView DataSource Methods
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
	return [datesArray count];
}

#pragma mark - HorizontalPickerView Delegate Methods
- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
    NSDate *tmpDate = [self.dateConvertReverse dateFromString:[datesArray objectAtIndex:index]];

    return [self.dateConvert stringFromDate:tmpDate];
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
    return 80;
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
    indexCount = index;
    self.date = [datesArray objectAtIndex:index];
    
    self.urlGetNews = [NSString stringWithFormat:@"%@api.php?act=getByChannel&id=%@&date=%@",kDomain,[chanel objectForKey:@"id"],self.date];
    
    [self reloadNews:self.urlGetNews];
}


-(IBAction)nextDay:(id)sender{
	indexCount += 1;
	[pickerView scrollToElement:indexCount animated:YES];
	if ([datesArray count] <= indexCount) {
		indexCount = 0;
	}
}

-(IBAction)prevDay:(id)sender{
	if (0 == indexCount) {
		indexCount = [datesArray count];
	}
	indexCount -= 1;
	[pickerView scrollToElement:indexCount animated:YES];
}


@end

//
//  ViewController.m
//  HTListView
//
//  Created by Hai Trieu on 11/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "SBJson.h"
#import "IIViewDeckController.h"
#import "AppDelegate.h"
#import "EGOImageView.h"
#import "SVPullToRefresh.h"
#import "TDSemiModal.h"
#import "ChanelDetailViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "HomeCell.h"
#import "UINavigationBar+BackgroundImage.h"

@interface ViewController() 

-(void)getDateAndTime:(NSDate*)date;
-(void)getEvents;

@end

@implementation ViewController

@synthesize indexPath = _indexPath;
@synthesize datePickerView = _datePickerView;
@synthesize pickerView;
@synthesize headerHome;
@synthesize hour = _hour;
@synthesize date = _date;


#pragma mark - iVars
NSMutableArray *timeArray;
int indexCount;

AppDelegate *appDelegate;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (id)initWithNibName:(NSString *)nibName
               bundle:(NSBundle *)nibBundle {
    self = [super initWithNibName:nibName
                           bundle:nibBundle];
    if (self) {
        appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.tracker trackView:@"HTVC"];
        self.title = @"HTVC";
    }
    return self;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //test something for github
    
    /*Navigation bar*/
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_Logo.png"]];
    self.navigationItem.titleView = titleImage;
    UIImage *backgroundImage = [UIImage imageNamed:@"Top_Bar_Menu_Background.png"];
    
    if (kOsVersion < 5.0) {
        self.navigationController.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage];
    }
    
    /*
    UIImageView *titleView = (UIImageView *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
        titleView.image = [UIImage imageNamed:@"Home_Logo.png"];
        [self.navigationItem setTitleView:titleView];
        [titleView release];
    }
    */
    UIImage* imageDate = [UIImage imageNamed:@"Top_Bar_Day_Icon.png"];
    CGRect frameimgDate = CGRectMake(0, 8, imageDate.size.width, imageDate.size.height);
    UIButton *dateBtn = [[UIButton alloc] initWithFrame:frameimgDate];
    [dateBtn setBackgroundImage:imageDate forState:UIControlStateNormal];
    [dateBtn addTarget:self action:@selector(chooseDate)
      forControlEvents:UIControlEventTouchUpInside];
    [dateBtn setShowsTouchWhenHighlighted:YES];
    
    UIImage* imageAlarm = [UIImage imageNamed:@"Top_Bar_Reminder_Icon.png"];
    CGRect frameimgAlarm = CGRectMake(40, 8, imageAlarm.size.width, imageAlarm.size.height);
    UIButton *alarmBtn = [[UIButton alloc] initWithFrame:frameimgAlarm];
    [alarmBtn setBackgroundImage:imageAlarm forState:UIControlStateNormal];
    [alarmBtn addTarget:self action:@selector(alarmBtnClick:)
      forControlEvents:UIControlEventTouchUpInside];
    [alarmBtn setShowsTouchWhenHighlighted:YES];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    
    UIView *leftItems = [[UIView alloc] initWithFrame:CGRectMake(0,0, 74,44)];
    [toolbar setFrame:CGRectMake(0,0, 64,44)];
    
    [leftItems addSubview:alarmBtn];
    [leftItems addSubview:dateBtn];
    
    UIBarButtonItem *customBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftItems];
    
    [toolbar setTranslucent:YES];
    
    self.navigationItem.rightBarButtonItem = customBarButton;
    

    UIImage* menuImg = [UIImage imageNamed:@"top_bar_menu_icon.png"];
    CGRect frameMenuImg = CGRectMake(0, 0, menuImg.size.width, menuImg.size.height);
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:frameMenuImg];
    [menuBtn setBackgroundImage:menuImg forState:UIControlStateNormal];
    [menuBtn addTarget:self.viewDeckController action:@selector(toggleLeftView)
      forControlEvents:UIControlEventTouchUpInside];
    [menuBtn setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *menuPage =[[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.leftBarButtonItem = menuPage;
    

    
    
    /*Sideview*/
    
    self.viewDeckController.leftLedge = 60;
    self.viewDeckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;

    
    /*Select time*/
    
    timeArray = [[[NSMutableArray alloc] init] retain];
    for (int i = 0; i < 24; i++) {
        NSString *even = [NSString stringWithFormat:@"%d:00",i];
        [timeArray addObject:even];
        NSString *odd = [NSString stringWithFormat:@"%d:30",i];
        [timeArray addObject:odd];
    }
    indexCount = 1;

    if (_hour == nil) {
        self.hour = [[NSString alloc] init];
    }
    if (_date == nil) {
        self.date = [[NSString alloc] init];
    }
    
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

    [self.headerHome addSubview:pickerView];

    /*Others init*/
    self.tableView.showsInfiniteScrolling = NO;
    UIImageView *footer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 88)];
    footer.image = [UIImage imageNamed:@"Home_Each_Row_Background.png"];
    self.tableView.tableFooterView = footer;
    
    dateFormater = [[NSDateFormatter alloc] init];
    NSDate *now = [[NSDate alloc] init];
    [dateFormater setDateFormat:@"H"];
    indexCount = [[dateFormater stringFromDate:now] intValue] * 2;
    [dateFormater setDateFormat:@"mm"];
    if ([[dateFormater stringFromDate:now] intValue] >= 30) {
        indexCount += 1;
    }
    
    [pickerView scrollToElement:indexCount animated:YES];
    [self getDateAndTime:now];
    
    /*Fetch data*/
    [self getEvents];

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

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
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//    return YES;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerHome;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.headerHome.frame.size.height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HomeCell";
    
    NSDictionary *item = [self.arrayNews objectAtIndex:indexPath.row];
    
    HomeCell *cell = (HomeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (HomeCell*)[nib objectAtIndex:0];
        }
    
    cell.thumb.imageURL = [NSURL URLWithString:[item objectForKey:@"logo"]];
    cell.chanelName.text = [item objectForKey:@"name"];
    if ([[item objectForKey:@"programs"] count] > 0) {
        cell.time1.text = [[[[item objectForKey:@"programs"] objectAtIndex:0] objectForKey:@"start_time"] substringWithRange:NSMakeRange(11, 5)];
        cell.program1.text = [[[item objectForKey:@"programs"] objectAtIndex:0] objectForKey:@"name"];
    }
    if ([[item objectForKey:@"programs"] count] > 1) {    
        cell.time2.text = [[[[item objectForKey:@"programs"] objectAtIndex:1] objectForKey:@"start_time"] substringWithRange:NSMakeRange(11, 5)];
        cell.program2.text = [[[item objectForKey:@"programs"] objectAtIndex:1] objectForKey:@"name"];
    }
    if ([[item objectForKey:@"programs"] count] > 2) {    
    cell.time3.text = [[[[item objectForKey:@"programs"] objectAtIndex:2] objectForKey:@"start_time"] substringWithRange:NSMakeRange(11, 5)];
    cell.program3.text = [[[item objectForKey:@"programs"] objectAtIndex:2] objectForKey:@"name"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *item = [self.arrayNews objectAtIndex:indexPath.row];
    ChanelDetailViewController *chanelDetail = [[[ChanelDetailViewController alloc] initWithNibName:@"ChanelDetailViewController" bundle:nil andChanel:item] autorelease];
    [self.navigationController pushViewController:chanelDetail animated:YES];
    
}

-(void)chanelSelected:(NSDictionary*)chanel{
    ChanelDetailViewController *chanelDetail = [[[ChanelDetailViewController alloc] initWithNibName:@"ChanelDetailViewController" bundle:nil andChanel:chanel] autorelease];
    [self.navigationController pushViewController:chanelDetail animated:YES];
}

-(void)processResponse:(NSString*)responseString{
    
    NSArray *tmpNews = [[responseString JSONValue] objectForKey:@"channels"];
    
    [self updateTableView:tmpNews];
}


#pragma mark - HorizontalPickerView DataSource Methods
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
	return [timeArray count];
}

#pragma mark - HorizontalPickerView Delegate Methods
- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
	return [timeArray objectAtIndex:index];
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
    return 80;
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
    indexCount = index;
    self.hour = [timeArray objectAtIndex:index];
    [self getEvents];
}


-(IBAction)nextHour:(id)sender{
	indexCount += 1;
	[pickerView scrollToElement:indexCount animated:YES];
	if ([timeArray count] <= indexCount) {
		indexCount = 0;
	}
}

-(IBAction)prevHour:(id)sender{
	if (0 == indexCount) {
		indexCount = [timeArray count];
	}
	indexCount -= 1;
	[pickerView scrollToElement:indexCount animated:YES];
}

-(void)chooseDate{
    if (_datePickerView == nil) {
        self.datePickerView = [[[TDDatePickerController alloc] initWithNibName:@"TDDatePickerController" bundle:nil] autorelease];
        self.datePickerView.delegate = self;
    }
    [self presentSemiModalViewController:_datePickerView];
}


#pragma mark -
#pragma mark Date Picker Delegate

-(void)datePickerSetDate:(TDDatePickerController*)viewController {
	[self dismissSemiModalViewController:_datePickerView];
    
    [self getDateAndTime:viewController.datePicker.date];
    
    [self getEvents];
}

-(void)datePickerClearDate:(TDDatePickerController*)viewController {
	[self dismissSemiModalViewController:_datePickerView];
    
//	selectedDate = nil;
}

-(void)datePickerCancel:(TDDatePickerController*)viewController {
	[self dismissSemiModalViewController:_datePickerView];
}

/*Private function*/

-(void)getDateAndTime:(NSDate*)date{
    
    [dateFormater setDateFormat:@"Y-MM-d"];
    self.date = [dateFormater stringFromDate:date];
    [dateFormater setDateFormat:@"H:mm:ss"];
    self.hour = [dateFormater stringFromDate:date];

}

-(void)getEvents{
    
    self.urlGetNews = [NSString stringWithFormat:@"%@api.php?act=getByTime&date=%@&time=%@",kDomain,_date,_hour];
    
    [self reloadNews:self.urlGetNews];
    
}
@end

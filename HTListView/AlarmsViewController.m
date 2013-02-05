//
//  AlarmsViewController.m
//  HTVC
//
//  Created by Hai Trieu on 1/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AlarmsViewController.h"
#import "AlarmCell.h"
#import "SVPullToRefresh.h"
#import "IIViewDeckController.h"
#import "OLGhostAlertView.h"

@interface AlarmsViewController ()

-(void)deleteLocalNotification:(NSDictionary*)info;

@end

@implementation AlarmsViewController
@synthesize database = _database;
@synthesize times;
@synthesize itemForAlarm = _itemForAlarm;

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
    self.title = @"Hẹn thông báo";

    self.tableView.showsPullToRefresh = NO;
    self.tableView.showsInfiniteScrolling = NO;
    UIImageView *footer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 88)];
    footer.image = [UIImage imageNamed:@"Home_Each_Row_Background.png"];
    self.tableView.tableFooterView = footer;
    
    self.database = [FMDatabase databaseWithPath:SharedAppDelegate.databasePath];
    [self.database open];
    times = timesBefore;

    /*NavigationBar init*/
    UIImageView *bgAlarmBtn = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 36, 34)];
    bgAlarmBtn.image = [UIImage imageNamed: @"Reminder_Icon_Background.png"];
    UIImageView *alarmIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12, 28, 28)];
    alarmIcon.image = [UIImage imageNamed:@"Top_Bar_Reminder_Icon.png"];
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    
    [container addSubview:bgAlarmBtn];
    [container addSubview:alarmIcon];
    [bgAlarmBtn release];
    [alarmIcon release];
    
    UIBarButtonItem *alarmPage =[[UIBarButtonItem alloc] initWithCustomView:container];
    
    self.navigationItem.rightBarButtonItem = alarmPage;

    self.navigationItem.leftBarButtonItem = bttBack;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.viewDeckController.panningMode = IIViewDeckNavigationBarPanning;
    
    [self.arrayNews removeAllObjects];
    
    FMResultSet *results = [self.database executeQuery:@"SELECT * FROM alarms ORDER BY id DESC"];
    NSMutableDictionary *dict;
    
    while([results next]) {
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[results stringForColumn:@"id"] forKey:@"id"];
        [dict setObject:[results stringForColumn:@"logo"] forKey:@"logo"];
        [dict setObject:[results stringForColumn:@"chanel_name"] forKey:@"chanel_name"];
        [dict setObject:[results stringForColumn:@"program_name"] forKey:@"program_name"];
        [dict setObject:[results stringForColumn:@"start_time"] forKey:@"start_time"];
        [dict setObject:[results stringForColumn:@"before"] forKey:@"before"];
        [self.arrayNews addObject:dict];
        [dict release];
    }
    
    [[self tableView] reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    
    [super viewWillDisappear:animated];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AlarmCell";
    
    NSDictionary *item = [self.arrayNews objectAtIndex:indexPath.row];
    
    AlarmCell *cell = (AlarmCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
        {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (AlarmCell*)[nib objectAtIndex:0];
        }
    
    cell.thumb.imageURL = [NSURL URLWithString:[item objectForKey:@"logo"]];
    cell.chanelName.text = [item objectForKey:@"chanel_name"];
    cell.programName.text = [item objectForKey:@"program_name"];
    cell.startTime.text = [NSString stringWithFormat:@"Thời gian: %@",[item objectForKey:@"start_time"]];
    NSString *before = [times objectAtIndex:[[item objectForKey:@"before"] intValue]];
    cell.before.text = [NSString stringWithFormat:@"Thông báo trước %@",before];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showWithAnimated:pkBeforeView withAnimated:0.3];
    self.itemForAlarm = [self.arrayNews objectAtIndex:indexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Xóa";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *item = [self.arrayNews objectAtIndex:indexPath.row];

        [self deleteLocalNotification:item];
        NSString *query = [NSString stringWithFormat:@"DELETE FROM alarms WHERE id = %@",[item objectForKey:@"id"]];

        [self.database executeUpdate:query];

        [self.arrayNews removeObjectAtIndex:indexPath.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
        [self.tableView endUpdates];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        //your function
    }   
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

        NSString *query = [NSString stringWithFormat:@"UPDATE alarms SET before = %d WHERE id = %@",index,[self.itemForAlarm objectForKey:@"id"]];
        [self.database executeUpdate:query];

        
        NSDictionary *infoNotification = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",[self.database lastInsertRowId]],@"id", nil];
        
        
        [[MKLocalNotificationsScheduler sharedInstance] scheduleNotificationOn:timeForAlarm text:[self.itemForAlarm objectForKey:@"name"] action:@"Xem" sound:nil launchImage:nil andInfo:infoNotification];
        [self viewWillAppear:YES];
        
    }
    
}

-(void)deleteLocalNotification:(NSDictionary*)info{
    NSString *notificationId = [info objectForKey:@"id"];
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    NSLog(@"number of even %d",[eventArray count]);
    for (int i=0; i<[eventArray count]; i++)
        {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"id"]];
        if ([uid isEqualToString:notificationId])
            {
            //Cancelling local notification
            [app cancelLocalNotification:oneEvent];
            break;
            }
        }
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

@end

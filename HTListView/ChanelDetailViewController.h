//
//  ChanelDetailViewController.h
//  HTVC
//
//  Created by Hai Trieu on 1/28/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTListView.h"
#import "EGOImageView.h"
#import "FMDatabase.h"
#import "V8HorizontalPickerView.h"
#import "MKLocalNotificationsScheduler.h"

@interface ChanelDetailViewController : HTListView<V8HorizontalPickerViewDataSource,V8HorizontalPickerViewDelegate>{
    NSDictionary * chanel;
    IBOutlet UIView *pkBeforeView;
    IBOutlet UIPickerView *pkBefore;
    
}

@property (nonatomic, retain) NSDateFormatter *dateConvert;
@property (nonatomic, retain) NSDateFormatter *dateConvertReverse;
@property (nonatomic, retain) IBOutlet UIView *header;
@property (nonatomic, retain) IBOutlet EGOImageView *thumb;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *description;
@property (nonatomic, retain) IBOutlet UIButton *like;
@property (nonatomic, retain) IBOutlet UIButton *unlike;
@property (nonatomic, retain) V8HorizontalPickerView *pickerView;
@property (nonatomic, retain) FMDatabase *database;
@property (nonatomic, retain) NSArray *times;
@property (nonatomic, retain) NSDictionary *itemForAlarm;
@property (nonatomic, retain) NSString *date;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andChanel:(NSDictionary*)_chanel;

-(IBAction)unlikeBtnClick:(id)sender;
-(IBAction)likeBtnClick:(id)sender;

-(IBAction)cancelBtnClick:(id)sender;
-(IBAction)setBtnClick:(id)sender;
-(IBAction)nextDay:(id)sender;
-(IBAction)prevDay:(id)sender;

@end

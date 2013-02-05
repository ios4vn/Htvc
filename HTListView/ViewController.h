//
//  ViewController.h
//  HTListView
//
//  Created by Hai Trieu on 11/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTListView.h"
#import "V8HorizontalPickerView.h"
#import "TDDatePickerController.h"

@class V8HorizontalPickerView;

@interface ViewController : HTListView<UIActionSheetDelegate,V8HorizontalPickerViewDataSource,V8HorizontalPickerViewDelegate>{
    
    NSDateFormatter *dateFormater;
    
}

@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *hour;
@property (nonatomic, retain) TDDatePickerController* datePickerView;
@property (nonatomic, retain) IBOutlet UIView *headerHome;
@property (nonatomic, retain) V8HorizontalPickerView *pickerView;
@property (retain, nonatomic) NSIndexPath *indexPath;

-(IBAction)nextHour:(id)sender;
-(IBAction)prevHour:(id)sender;

-(void)chanelSelected:(NSDictionary*)chanel;

@end

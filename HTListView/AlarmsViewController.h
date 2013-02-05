//
//  AlarmsViewController.h
//  HTVC
//
//  Created by Hai Trieu on 1/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTListView.h"
#import "FMDatabase.h"

@interface AlarmsViewController : HTListView{
    IBOutlet UIView *pkBeforeView;
    IBOutlet UIPickerView *pkBefore;
}

@property (nonatomic, retain) FMDatabase *database;
@property (nonatomic, retain) NSArray *times;
@property (nonatomic, retain) NSDictionary *itemForAlarm;

-(IBAction)cancelBtnClick:(id)sender;
-(IBAction)setBtnClick:(id)sender;

@end

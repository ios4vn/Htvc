//
//  StandarViewController.h
//  Redcafe
//
//  Created by Hai Trieu on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"

@interface StandarViewController : GAITrackedViewController{
    UIBarButtonItem *bttBack;
    UIBarButtonItem *bttAlarm;
}

-(void)alarmBtnClick:(id)sender;

@end

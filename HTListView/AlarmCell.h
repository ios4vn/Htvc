//
//  AlarmCell.h
//  HTVC
//
//  Created by Hai Trieu on 1/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface AlarmCell : UITableViewCell
{
    
}

@property(nonatomic, retain) IBOutlet EGOImageView *thumb;
@property(nonatomic, retain) IBOutlet UILabel *chanelName;
@property(nonatomic, retain) IBOutlet UILabel *programName;
@property(nonatomic, retain) IBOutlet UILabel *startTime;
@property(nonatomic, retain) IBOutlet UILabel *before;

@end

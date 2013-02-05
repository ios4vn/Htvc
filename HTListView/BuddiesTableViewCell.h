//
//  BuddiesTableViewCell.h
//  FishyPic
//
//  Created by Do Nguyen Luong on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGOImageButton.h"

@interface BuddiesTableViewCell : UITableViewCell{
    
    UILabel *desc;
    UIButton *shareBtn;
    EGOImageButton *imgMain;
    UILabel *numOfViews;
    UILabel *numOfShare;

}

@property (nonatomic, retain) IBOutlet UILabel *desc;
@property (nonatomic, retain) IBOutlet UIButton *shareBtn;
@property (nonatomic, retain) IBOutlet EGOImageButton *imgMain;
@property (nonatomic, retain) IBOutlet UILabel *numOfViews;
@property (nonatomic, retain) IBOutlet UILabel *numOfShare;
@end

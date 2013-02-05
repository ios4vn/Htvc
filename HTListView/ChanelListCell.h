//
//  ChanelListCell.h
//  HTVC
//
//  Created by Hai Trieu on 1/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface ChanelListCell : UITableViewCell{

}

@property (nonatomic, retain) IBOutlet EGOImageView *thumb;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *description;
@property (nonatomic, retain) IBOutlet UIButton *like;

@end

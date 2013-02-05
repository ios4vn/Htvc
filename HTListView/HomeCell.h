//
//  HomeCell.h
//  HTVC
//
//  Created by Hai Trieu on 1/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface HomeCell : UITableViewCell
{

}

@property(nonatomic, retain) IBOutlet EGOImageView *thumb;
@property(nonatomic, retain) IBOutlet UILabel *chanelName;
@property(nonatomic, retain) IBOutlet UILabel *time1;
@property(nonatomic, retain) IBOutlet UILabel *program1;
@property(nonatomic, retain) IBOutlet UILabel *time2;
@property(nonatomic, retain) IBOutlet UILabel *program2;
@property(nonatomic, retain) IBOutlet UILabel *time3;
@property(nonatomic, retain) IBOutlet UILabel *program3;

@end

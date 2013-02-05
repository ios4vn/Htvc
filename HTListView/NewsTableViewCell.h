//
//  NewsTableViewCell.h
//  Redcafe
//
//  Created by Hai Trieu on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface NewsTableViewCell : UITableViewCell{
    EGOImageView *_thumb;
    UILabel *_title;
    UILabel *_detail;
    UILabel *_numOfViews;
    UILabel *_count;
    UILabel *_distant;
    UIButton *_shareFace;
}
@property (nonatomic, retain) IBOutlet EGOImageView *thumb;
@property (nonatomic, retain) IBOutlet UILabel *detail;
@property (nonatomic, retain) IBOutlet UILabel *count;
@property (nonatomic, retain) IBOutlet UILabel *distant;
@property (nonatomic, retain) IBOutlet UILabel *numOfViews;
@property (nonatomic, retain) IBOutlet UIButton *shareFace;

@end

//
//  NewsTableViewCell.m
//  Redcafe
//
//  Created by Hai Trieu on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell
@synthesize thumb = _thumb;
@synthesize detail = _detail;
@synthesize numOfViews = _numOfViews;
@synthesize count = _count;
@synthesize distant = _distant;
@synthesize shareFace = _shareFace;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        UIImageView *viewIcon;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _thumb = [[EGOImageView alloc] initWithFrame:CGRectMake(11, 4, 96, 71)];
            _detail = [[UILabel alloc] initWithFrame:CGRectMake(117, 0, 641, 59)];
            _numOfViews = [[UILabel alloc] initWithFrame:CGRectMake(139, 56, 115, 21)];
            viewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(117, 59, 16, 16)];
            _shareFace = [[UIButton alloc] initWithFrame:CGRectMake(736, 47, 32, 32)];
        }
        else{
            _thumb = [[EGOImageView alloc] initWithFrame:CGRectMake(11, 4, 96, 71)];
            _detail = [[UILabel alloc] initWithFrame:CGRectMake(116, 0, 200, 59)];
            _numOfViews = [[UILabel alloc] initWithFrame:CGRectMake(116, 76, 150, 21)];
            _count = [[UILabel alloc] initWithFrame:CGRectMake(116, 55, 94, 21)];
            _distant = [[UILabel alloc] initWithFrame:CGRectMake(234, 76, 76, 21)];
            viewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(117, 56, 16, 16)];
//            _shareFace = [[UIButton alloc] initWithFrame:CGRectMake(287, 48, 32, 32)];
        }
        
        _numOfViews.font = [UIFont italicSystemFontOfSize:12];
        _numOfViews.backgroundColor = [UIColor clearColor];
        _count.font = [UIFont italicSystemFontOfSize:12];
        _count.backgroundColor = [UIColor clearColor];
        _distant.font = [UIFont italicSystemFontOfSize:12];
        _distant.backgroundColor = [UIColor clearColor];
        _distant.textAlignment = UITextAlignmentRight;
        [_shareFace setImage:[UIImage imageNamed:@"share_facebook_icon.png"] forState:UIControlStateNormal];
//        UIImageView *background = [[UIImageView alloc] initWithFrame:self.contentView.frame];
//        background.image = [UIImage imageNamed:@"cell_bg.png"];
        _detail.font = [UIFont systemFontOfSize:14];
        _detail.numberOfLines = 4;
        _detail.backgroundColor = [UIColor clearColor];
        viewIcon.image = [UIImage imageNamed:@"content_status_view_icon.png"];
        
        
//        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"cell_bg.png"]];
//        self.contentView.backgroundColor = background;
//        [background release];
        
//        [self.contentView addSubview:viewIcon];
        [viewIcon release];
        
        [self.contentView addSubview:_thumb];
        [_thumb release];
        [self.contentView addSubview:_detail];
        [_detail release];
        [self.contentView addSubview:_numOfViews];
        [_numOfViews release];
        [self.contentView addSubview:_count];
        [_count release];
        [self.contentView addSubview:_distant];
        [_distant release];
//        [self.contentView addSubview:_shareFace];
//        [_shareFace release];
    }
    return self;
}

@end

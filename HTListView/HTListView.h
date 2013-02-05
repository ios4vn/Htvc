//
//  HTListView.h
//  HTListView
//
//  Created by Hai Trieu on 11/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "StandarViewController.h"

@interface HTListView : StandarViewController<FBSessionDelegate,FBDialogDelegate>{
    int pageNumber;
    //step to pagemove
    int pageSize;
    BOOL canLoadMore;
    NSString *keyword;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIView *footerIndicator;
@property (nonatomic, retain) NSMutableDictionary *itemForShare;

@property (nonatomic, retain) NSMutableArray *arrayNews;
@property (nonatomic, retain) NSString *urlGetNews;

-(void)reloadNews:(NSString*)urlAPI;
-(void)updateTableView:(NSArray *)tmpNews;
-(void)processResponse:(NSString*)responseString;

-(void)shareViaFacebook;

-(void)showWithAnimated:(UIView*)showView withAnimated:(float)duration;
-(void)hideWithAnimated:(UIView*)hideView withAnimated:(float)duration;

@end

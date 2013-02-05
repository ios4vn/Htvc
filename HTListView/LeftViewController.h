//
//  LeftViewController.h
//  ViewDeckExample
//


#import <UIKit/UIKit.h>
#import "HTListView.h"

@interface LeftViewController : HTListView{
    
}

@property (nonatomic, retain) IBOutlet UIView *header;
@property (nonatomic, retain) IBOutlet UIView *footer;

-(IBAction)chanelClick:(id)sender;
-(IBAction)infoClick:(id)sender;

-(void)reloadSideView;

@end

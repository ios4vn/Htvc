//
//  StandarViewController.m
//  Redcafe
//
//  Created by Hai Trieu on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "IIViewDeckController.h"
#import "StandarViewController.h"
#import "UINavigationBar+BackgroundImage.h"
#import "AlarmsViewController.h"

@implementation StandarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage* imageBack = [UIImage imageNamed:@"backbtn.png"];
    CGRect frameimgBack = CGRectMake(0, 8, imageBack.size.width, imageBack.size.height);
    UIButton *backBtn = [[UIButton alloc] initWithFrame:frameimgBack];
    [backBtn setBackgroundImage:imageBack forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backHomeMenu:)
      forControlEvents:UIControlEventTouchUpInside];
    [backBtn setShowsTouchWhenHighlighted:YES];
    
    bttBack = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = bttBack;

    UIImage* imageAlarm = [UIImage imageNamed:@"Top_Bar_Reminder_Icon.png"];
    CGRect frameimgAlarm = CGRectMake(0, 8, imageAlarm.size.width, imageAlarm.size.height);
    UIButton *alarmBtn = [[UIButton alloc] initWithFrame:frameimgAlarm];
    [alarmBtn setBackgroundImage:imageAlarm forState:UIControlStateNormal];
    [alarmBtn addTarget:self action:@selector(alarmBtnClick:)
      forControlEvents:UIControlEventTouchUpInside];
    [alarmBtn setShowsTouchWhenHighlighted:YES];
    
    bttAlarm = [[UIBarButtonItem alloc] initWithCustomView:alarmBtn];
    self.navigationItem.rightBarButtonItem = bttAlarm;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"Top_Bar_Menu_Background.png"];

    if (kOsVersion < 5.0) {
        self.navigationController.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage];
    }
    else{
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsLandscapePhone];
    }
    [backgroundImage release];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

-(void)backHomeMenu:(id)sender{
    if ([[self.navigationController viewControllers] count] == 1) {
       self.viewDeckController.centerController = SharedAppDelegate.navController;
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)alarmBtnClick:(id)sender{
    if (SharedAppDelegate.alarmsController == nil) {
        SharedAppDelegate.alarmsController = [[UINavigationController alloc] initWithRootViewController:[[AlarmsViewController alloc] initWithNibName:@"AlarmsViewController" bundle:nil]];
    }

    self.viewDeckController.centerController = SharedAppDelegate.alarmsController;
    
}
@end

//
//  AppDelegate.h
//  HTListView
//
//  Created by Hai Trieu on 11/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import <MapKit/MapKit.h>
#import "MKLocalNotificationsScheduler.h"

#import "GAI.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,FBSessionDelegate>{
    Facebook *facebook;
    NSString *databasePath;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *databasePath; 

@property(nonatomic, retain) id<GAITracker> tracker;
@property (strong, nonatomic) UINavigationController *navController;
@property (nonatomic, retain) UINavigationController *infoController;
@property (nonatomic, retain) UINavigationController *chanelController;
@property (nonatomic, retain) UINavigationController *alarmsController;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, readwrite, retain ) id<FBSessionDelegate> delegate;

@end

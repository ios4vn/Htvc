//
//  AppDelegate.m
//  HTListView
//
//  Created by Hai Trieu on 11/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "IIViewDeckController.h"
#import "ViewController.h"
#import "LeftViewController.h"
#import "FMDatabase.h"

/******* Set your tracking ID here *******/
static NSString *const kTrackingId = @"";

static NSString* kFacebookAppID = @"378859375530839";

@interface AppDelegate (Private)
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)deleteOldEvents:(FMDatabase*)database;
@end

@implementation AppDelegate

@synthesize tracker = _tracker;
@synthesize window = _window;
@synthesize navController = _navController;
@synthesize infoController = _infoController;
@synthesize chanelController = _chanelController;
@synthesize alarmsController = _alarmsController;
@synthesize delegate = _delegate;
@synthesize facebook;
@synthesize token = _token;
@synthesize databasePath;

- (void)dealloc
{
    [_window release];
    [_navController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self createEditableCopyOfDatabaseIfNeeded];
    /* Create database */
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: 
                                                      @"database.sqlite"]];
    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    
    [database open];
    [database executeUpdate:@"CREATE  TABLE 'main'.'alarms' ('id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , 'logo' TEXT, 'chanel_name' TEXT, 'program_name' TEXT, 'start_time' TEXT, 'before' INTEGER)"];
    [self deleteOldEvents:database];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];    
    
    facebook = [[Facebook alloc] initWithAppId:kFacebookAppID andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    if(![defaults objectForKey:@"token"]){
        ASIHTTPRequest *getToken = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@api.php?act=getToken",kDomain]]];
        [getToken startSynchronous];
        NSString *token = [[[getToken responseString] JSONValue] objectForKey:@"token"];
        self.token = token;
        [defaults setObject:token forKey:@"token"];
        [defaults synchronize];
    }
    else{
        self.token = [defaults objectForKey:@"token"];
    }
    
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
	
    if (localNotification) 
        {
        NSLog(@"local notifi here");
		[[MKLocalNotificationsScheduler sharedInstance] handleReceivedNotification:localNotification];
        }
    
    IIViewDeckController* deckController;
    
    LeftViewController *leftView = [[[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil] autorelease];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        ViewController *rootViewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
        self.navController = [[[UINavigationController alloc] initWithRootViewController:rootViewController] autorelease];
    } else {
        ViewController *rootViewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil] autorelease];
        self.navController = [[[UINavigationController alloc] initWithRootViewController:rootViewController] autorelease];
    }
    deckController = [[IIViewDeckController alloc] initWithCenterViewController:self.navController leftViewController:leftView];
    self.window.rootViewController = deckController;
    [self.window makeKeyAndVisible];

    
    return YES;
}

- (void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"database.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"database.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)localNotification {
    
	[[MKLocalNotificationsScheduler sharedInstance] handleReceivedNotification:localNotification];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.facebook handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.facebook handleOpenURL:url];
}


- (void)fbDidLogin {
    [self.delegate fbDidLogin];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
}

- (void)fbDidNotLogin:(BOOL)cancelled{
    
}

- (void)fbSessionInvalidated{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception"
                              message:@"Your session has expired."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    [alertView release];
}

- (void)fbDidLogout {
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)deleteOldEvents:(FMDatabase*)database{
    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *nowString = [format stringFromDate:now];
    NSString *query = [NSString stringWithFormat:@"DELETE FROM alarms WHERE start_time < '%@'",nowString];
    [database executeUpdate:query];
}

@end

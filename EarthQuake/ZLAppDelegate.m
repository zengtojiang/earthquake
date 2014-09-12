//
//  ZLAppDelegate.m
//  EarthQuake
//
//  Created by mac  on 12-12-2.
//  Copyright (c) 2012年 icow. All rights reserved.
//

#import "ZLAppDelegate.h"

#import "ZLRootViewController.h"
#import "Earthquake.h"
#import "ParseOperation.h"
#import "ZLHomeViewController.h"

@interface ZLAppDelegate ()

@property (nonatomic, retain) NSURLConnection *earthquakeFeedConnection;
@property (nonatomic, retain) NSMutableData *earthquakeData;    // the data returned from the NSURLConnection
@property (nonatomic, retain) NSOperationQueue *parseQueue;     // the queue that manages our NSOperation for parsing earthquake data

- (void)handleError:(NSError *)error;
@end
@implementation ZLAppDelegate

@synthesize navigationController;
@synthesize earthquakeFeedConnection;
@synthesize earthquakeData;
@synthesize parseQueue;

- (void)dealloc {
    [earthquakeFeedConnection cancel];
    [earthquakeFeedConnection release];
    
    [earthquakeData release];
    [navigationController release];
    [_viewController release];
    [_window release];
    
    [parseQueue release];
    
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:kAddEarthquakesNotif object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kEarthquakesErrorNotif object:nil];
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UIApplication sharedApplication].statusBarHidden=NO;
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    self.viewController = [[[ZLRootViewController alloc] init] autorelease];
    self.viewController.managedObjectContext = self.managedObjectContext;
    self.navigationController=[[[UINavigationController alloc] initWithRootViewController:self.viewController] autorelease];
    //self.navigationController.navigationBarHidden=YES;
    //self.navigationController.view.backgroundColor=[UIColor blackColor];
    //self.navigationController.view.frame=CGRectMake(0, IOS7_STATUSBAR_DELTA, 320, self.window.frame.size.height-IOS7_STATUSBAR_DELTA);
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    //UIImage *
    //[normalImage resizableImageWithCapInsets:UIEdgeInsetsMake(normalSize.height/2.0f,normalSize.width/2.0f,normalSize.height/2.0f,normalSize.width/2.0f) resizingMode:UIImageResizingModeStretch]
    //self.navigationController.navigationBar.frame=CGRectMake(0, IOS7_STATUSBAR_DELTA, 320, 44);
    self.navigationController.navigationBar.backgroundColor=[UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_bg.png"] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    if (!ISIOS7) {
        [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:-5 forBarMetrics:UIBarMetricsDefault];
    }
    //[[UINavigationBar appearance] setTitleVerticalPositionAdjustment:10 forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,
      [UIColor blackColor], UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],UITextAttributeTextShadowOffset,
      [UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_BIG_FONT_SIZE], UITextAttributeFont, nil]];
    
    /*
    self.viewController = [[[ZLHomeViewController alloc] init] autorelease];
    self.viewController.managedObjectContext = self.managedObjectContext;
   // self.navigationController=[[[UINavigationController alloc] initWithRootViewController:self.viewController] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    */
    [self onRefreshData];
    parseQueue = [NSOperationQueue new];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(addEarthquakes:)
//                                                 name:kAddEarthquakesNotif
//                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(earthquakesError:)
                                                 name:kEarthquakesErrorNotif
                                               object:nil];
    
     return YES;
}

-(void)onRefreshData{
    static NSString *feedURLString = @"http://earthquake.usgs.gov/eqcenter/catalogs/1day-M2.5.xml";
    NSURLRequest *earthquakeURLRequest =
    [NSURLRequest requestWithURL:[NSURL URLWithString:feedURLString]];
    self.earthquakeFeedConnection =
    [[[NSURLConnection alloc] initWithRequest:earthquakeURLRequest delegate:self] autorelease];
    
    // Test the validity of the connection object. The most likely reason for the connection object
    // to be nil is a malformed URL, which is a programmatic error easily detected during development.
    // If the URL is more dynamic, then you should implement a more flexible validation technique,
    // and be able to both recover from errors and communicate problems to the user in an
    // unobtrusive manner.
    NSAssert(self.earthquakeFeedConnection != nil, @"Failure to create URL connection.");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //[self.viewController setRefreshState:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

// applicationWillTerminate: saves changes in the application's managed object context before
// the application terminates.
//
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application, although it may be useful
            // during development. If it is not possible to recover from the error, display an alert
            // panel that instructs the user to quit the application by pressing the Home button.
            //
            ZLTRACE(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        }
    }
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

// The following are delegate methods for NSURLConnection. Similar to callback functions, this is
// how the connection object, which is working in the background, can asynchronously communicate back
// to its delegate on the thread from which it was started - in this case, the main thread.
//
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // check for HTTP status code for proxy authentication failures
    // anything in the 200 to 299 range is considered successful,
    // also make sure the MIMEType is correct:
    //
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ((([httpResponse statusCode]/100) == 2) && [[response MIMEType] isEqual:@"application/atom+xml"]) {
        self.earthquakeData = [NSMutableData data];
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:
                                  NSLocalizedString(@"HTTP Error",
                                                    @"Error message displayed when receving a connection error.")
                                                             forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"HTTP" code:[httpResponse statusCode] userInfo:userInfo];
        [self handleError:error];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [earthquakeData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if ([error code] == kCFURLErrorNotConnectedToInternet) {
        // if we can identify the error, we can present a more precise message to the user.
        NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:
         NSLocalizedString(@"No Connection Error",
                           @"Error message displayed when not connected to the Internet.")
                                    forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                         code:kCFURLErrorNotConnectedToInternet
                                                     userInfo:userInfo];
        [self handleError:noConnectionError];
    } else {
        // otherwise handle the error generically
        [self handleError:error];
    }
    self.earthquakeFeedConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.earthquakeFeedConnection = nil;
    
    // Spawn an NSOperation to parse the earthquake data so that the UI is not blocked while the
    // application parses the XML data.
    //
    // IMPORTANT! - Don't access or affect UIKit objects on secondary threads.
    //
    ParseOperation *parseOperation = [[ParseOperation alloc] initWithData:self.earthquakeData];
    [self.parseQueue addOperation:parseOperation];
    [parseOperation release];   // once added to the NSOperationQueue it's retained, we don't need it anymore
    
    // have our rootViewController observe the ParseOperation's save operation with its managed object context
    [[NSNotificationCenter defaultCenter] addObserver:self.viewController
                                             selector:@selector(mergeChanges:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:parseOperation.managedObjectContext];
    
    // earthquakeData will be retained by the NSOperation until it has finished executing,
    // so we no longer need a reference to it in the main thread.
    self.earthquakeData = nil;
}

// Handle errors in the download by showing an alert to the user. This is a very
// simple way of handling the error, partly because this application does not have any offline
// functionality for the user. Most real applications should handle the error in a less obtrusive
// way and provide offline functionality to the user.
//
- (void)handleError:(NSError *)error {
    NSString *errorMessage = [error localizedDescription];
    ZLTRACE(@"error:%@",errorMessage);
    /*
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:nil
                               message:errorMessage
                              delegate:nil
                     cancelButtonTitle:NSLocalizedString(@"OK",nil)
                     otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    */
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //[self.viewController setRefreshState:NO];
}

// Our NSNotification callback from the running NSOperation when a parsing error has occurred
//
- (void)earthquakesError:(NSNotification *)notif {
    assert([NSThread isMainThread]);
    
    [self handleError:[[notif userInfo] valueForKey:kEarthquakesMsgErrorKey]];
}


#pragma mark -
#pragma mark Core Data stack

// Returns the path to the application's documents directory.
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
//
- (NSManagedObjectContext *)managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [NSManagedObjectContext new];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
//
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    return managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it
//
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Earthquakes.sqlite"];
	
	// set up the backing store
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Earthquakes" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
	
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate.
        // You should not use this function in a shipping application, although it may be useful
        // during development. If it is not possible to recover from the error, display an alert
        // panel that instructs the user to quit the application by pressing the Home button.
        //
        
        // Typical reasons for an error here include:
        // The persistent store is not accessible
        // The schema for the persistent store is incompatible with current managed object model
        // Check the error message to determine what the actual problem was.
        //
		ZLTRACE(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
    return persistentStoreCoordinator;
}

@end

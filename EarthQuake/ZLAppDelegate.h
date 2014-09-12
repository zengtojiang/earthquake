//
//  ZLAppDelegate.h
//  EarthQuake
//
//  Created by mac  on 12-12-2.
//  Copyright (c) 2012年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSNavigationController.h"

@class ZLRootViewController;
@class ZLHomeViewController;

@interface ZLAppDelegate : UIResponder <UIApplicationDelegate,NSXMLParserDelegate>
{
    UINavigationController *navigationController;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
@private
    // for downloading the xml data
    NSURLConnection *earthquakeFeedConnection;
    NSMutableData *earthquakeData;
    
    NSOperationQueue *parseQueue;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ZLRootViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)onRefreshData;
@end

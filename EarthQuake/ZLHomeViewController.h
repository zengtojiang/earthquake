//
//  ZLHomeViewController.h
//  EarthQuake
//
//  Created by mac  on 13-5-12.
//  Copyright (c) 2013年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLNewsMapViewController.h"
#import "ZLAttentionViewController.h"

@interface ZLHomeViewController : UIViewController<NSFetchedResultsControllerDelegate>
{
    NSManagedObjectContext *managedObjectContext;
    NSFetchedResultsController *fetchedResultsController;
    NSDate *twoWeeksAgo;
    ZLNewsMapViewController *newestMapVC;
    ZLAttentionViewController *attentionVC;
    
}
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSDate *twoWeeksAgo;
@end

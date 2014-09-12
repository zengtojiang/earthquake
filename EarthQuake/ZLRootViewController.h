//
//  ZLRootViewController.h
//  EarthQuake
//
//  Created by mac  on 12-12-2.
//  Copyright (c) 2012年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLAlertView.h"
#import "HSNavigationController.h"
#import "ZLProductCell.h"

@interface ZLRootViewController :  UIViewController <NSFetchedResultsControllerDelegate,ZLProductCellDelegate,UICollectionViewDelegate, UICollectionViewDataSource>
{
    UICollectionView     *mCollectionView;
    // This date formatter is used to convert NSDate objects to NSString objects, using the user's preferred formats.
    NSDateFormatter *dateFormatter;
    
@private
    NSManagedObjectContext *managedObjectContext;
    NSFetchedResultsController *fetchedResultsController;
    NSFetchedResultsController *fetchedSearchResultsController;
    NSMutableArray  *searchResults;
    
    NSDate *twoWeeksAgo;
    
    UIBarButtonItem *refreshBar;
    UIBarButtonItem *activityBar;
    
    BOOL         isTextChanged;
}
@property (nonatomic, retain, readonly) NSDateFormatter *dateFormatter;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *fetchedSearchResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSDate *twoWeeksAgo;  // used for dumping older earthquakes
@property(nonatomic,retain)UISearchBar  *searchBar;
@property(nonatomic,retain)UISearchDisplayController *searchDc;
-(void)setRefreshState:(BOOL)refresh;
@end

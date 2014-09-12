//
//  ZLRootViewController.m
//  EarthQuake
//
//  Created by mac  on 12-12-2.
//  Copyright (c) 2012年 icow. All rights reserved.
//

#import "ZLRootViewController.h"
#import "Earthquake.h"
#import "ZLAppDelegate.h"
#import "ZLMapViewController.h"
#import "ZLNewsMapViewController.h"
#import "ZLProductCell.h"

@interface ZLRootViewController ()
-(void)onRefresh;
@end

@implementation ZLRootViewController

@synthesize managedObjectContext, fetchedResultsController, twoWeeksAgo;
@synthesize searchBar,searchDc,fetchedSearchResultsController;

- (id)init
{
    self = [super init];
    if (self) {
        
       // NSTimeZone
        //NSCurrentLocaleDidChangeNotification
        searchResults=[[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

-(void)dealloc
{
    [dateFormatter release];
    
    [fetchedResultsController release];
    [fetchedSearchResultsController release];
	[managedObjectContext release];
    
    [twoWeeksAgo release];
    [refreshBar release];
    [activityBar release];
    [searchBar release];
    [searchDc release];
    [searchResults release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *bgView=[[UIImageView alloc] initWithFrame:self.view.bounds];
    bgView.image=[UIImage imageNamed:iPhone5?@"Default-568h.png":@"Default.png"];
    [self.view addSubview:bgView];
    self.navigationItem.title=NSLocalizedString(@"Earthquake",nil);
    if (refreshBar==nil)
    {
        UIButton * btnMap=[UIButton buttonWithType:UIButtonTypeCustom];
        //[btnMap setBackgroundImage:[UIImage imageNamed:@"buttonBlue.png"] forState:UIControlStateNormal];
        btnMap.frame=CGRectMake(0,0,32,32);
        //[btnMap stretchImage];
        [btnMap setImage:[UIImage imageNamed:@"refresh2.png"] forState:UIControlStateNormal];
        [btnMap addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventTouchUpInside];
        refreshBar=[[UIBarButtonItem alloc] initWithCustomView:btnMap];
        
        //refreshBar=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh2.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(onRefresh)];
        //refreshBar=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onRefresh)];
    }
    
    if (activityBar==nil)
    {
        UIActivityIndicatorView *act=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [act startAnimating];
        activityBar=[[UIBarButtonItem alloc] initWithCustomView:act];
        [act release];
    }
    
    self.navigationItem.leftBarButtonItem=refreshBar;
    
   HSStretchableButton * btnMap=[HSStretchableButton buttonWithType:UIButtonTypeCustom];
    [btnMap setBackgroundImage:[UIImage imageNamed:@"buttonGreen.png"] forState:UIControlStateNormal];
    [btnMap setBackgroundImage:[UIImage imageNamed:@"buttonGreen_disabled.png"] forState:UIControlStateHighlighted];
    btnMap.frame=CGRectMake(0,0,50,30);
    [btnMap stretchImage];
    [btnMap setTitle:NSLocalizedString(@"Map",nil) forState:UIControlStateNormal];
    btnMap.titleLabel.font=[UIFont fontWithName:@"ChalkboardSE-Bold" size:ZL_MIDDLE_FONT_SIZE];
    btnMap.titleLabel.textAlignment=NSTextAlignmentRight;
    [btnMap setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMap addTarget:self action:@selector(onTapMapBar) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *mapBar=[[UIBarButtonItem alloc] initWithCustomView:btnMap];
    self.navigationItem.rightBarButtonItem=mapBar;
    [mapBar release];
    
    [self initCollectionView];
    /*
    UIButton *analizyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [analizyBtn setTitle:NSLocalizedString(@"distribution", nil) forState:UIControlStateNormal];
    [analizyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    analizyBtn.backgroundColor=[UIColor brownColor];
    //[analizyBtn setTintColor:[UIColor brownColor]];
    analizyBtn.frame=CGRectMake(0, 44, ZLSCREEN_WIDTH, 30);
    [theHeaderView addSubview:analizyBtn];
    [analizyBtn addTarget:self action:@selector(onShowDistribution) forControlEvents:UIControlEventTouchUpInside];
    */
    NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate.
        // You should not use this function in a shipping application, although it may be useful
        // during development. If it is not possible to recover from the error, display an alert
        // panel that instructs the user to quit the application by pressing the Home button.
        //
        ZLTRACE(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    // compute the date two weeks ago from today, used later when dumping old earthquakes
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:-14];  // 14 days back from today
    self.twoWeeksAgo = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    [offsetComponents release];
    [gregorian release];
    
    /*
    UIBarButtonItem *backBar=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backIcon6.png"] style:UIBarButtonItemStylePlain target:nil action:NULL];
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    //[btnBack setTitle:@"Cancel" forState:UIControlStateNormal];
    UIImage *buttonImage=[UIImage imageNamed:@"backIcon6.png"];
    [btnBack setImage:buttonImage forState:UIControlStateNormal];//@"buttonGreen.png"
    btnBack.frame=CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    //[btnBack addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBar=[[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    self.navigationItem.backBarButtonItem=backBar;
    [backBar release];
     */
}

/*
-(void)initNavigationBar
{
    UIImageView *bgView=[[UIImageView alloc] initWithFrame:self.view.bounds];
    bgView.image=[UIImage imageNamed:iPhone5?@"Default-568h.png":@"Default.png"];
    [self.view addSubview:bgView];
    //    UIImageView *bgView=[[UIImageView alloc] initWithFrame:self.view.bounds];
    //    bgView.image=[UIImage imageNamed:@"theme2.jpg"];
    //    [self.view addSubview:bgView];
    
    HSStretchableImageView *imvHead=[[HSStretchableImageView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, ZL_HEADVIEW_HEIGHT-20)];
    imvHead.image=[UIImage imageNamed:@"skillbg6.png"];//tabbg2.png
    [imvHead stretchImage];
    //imvHead.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbarBlue.png"]];
    [self.view addSubview:imvHead];
    
    UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, ZL_HEADVIEW_HEIGHT-20-5)];
    lblTitle.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_BIG_FONT_SIZE];
    lblTitle.text=NSLocalizedString(@"Mall",nil);
    lblTitle.textColor=ZL_HEADVIEW_TEXTCOLOR;//[UIColor whiteColor];
    lblTitle.textAlignment=NSTextAlignmentCenter;
    lblTitle.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lblTitle];
    
    //    UIButton *btnShop=[UIButton buttonWithType:UIButtonTypeCustom];
    //    UIImage *buttonImage=[UIImage imageNamed:@"gotoshop.png"];
    //    [btnShop setBackgroundImage:buttonImage forState:UIControlStateNormal];//@"buttonGreen.png"
    //    btnShop.frame=CGRectMake(self.view.frame.size.width-buttonImage.size.width-10, (ZL_HEADVIEW_HEIGHT-20-buttonImage.size.height)/2+20, buttonImage.size.width, buttonImage.size.height);
    //    //[btnShop setTitle:@"Shop" forState:UIControlStateNormal];
    //    btnShop.titleLabel.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
    //    [btnShop setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    //[btnShop stretchImage];
    //    [self.view addSubview:btnShop];
    //    [btnShop addTarget:self action:@selector(onTapShopButton) forControlEvents:UIControlEventTouchUpInside];
}
*/

-(void)setNavigationBar
{
    /*
    activityBar=[[HSNavigationBarButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 0, 60, 44)];
    [activityBar setLeftNavigationBar:NO];
    //activityBar.hidden=YES;
    activity =[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.frame=CGRectMake(12, 4, 36, 36);
    activity.transform = CGAffineTransformMakeScale(0.80, 0.80);
    [activityBar addSubview:activity];
    [activity release];
     */
}

-(void)initCollectionView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //UICollectionViewLayout *collectionViewLayout=
    mCollectionView=[[UICollectionView alloc] initWithFrame:ISIOS7?CGRectMake(0, ZL_HEADVIEW_HEIGHT, self.view.frame.size.width, self.view.frame.size.height-ZL_HEADVIEW_HEIGHT):CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-ZL_HEADVIEW_HEIGHT) collectionViewLayout:flowLayout];//[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    mCollectionView.backgroundColor=[UIColor clearColor];
    //    UIImageView *bgView=[[UIImageView alloc] initWithFrame:self.view.bounds];
    //    bgView.image=[UIImage imageNamed:@"bg2.jpg"];
    //    mCollectionView.backgroundView=bgView;
    [mCollectionView registerClass:[ZLProductCell class] forCellWithReuseIdentifier:@"productcell"];
    mCollectionView.delegate=self;
    ///mCollectionView.separatorStyle=UITableViewCellSeparatorStyleNone;
    mCollectionView.dataSource=self;
    [self.view addSubview:mCollectionView];
}

-(void)onShowDistribution{
    ZLNewsMapViewController *analyzeVC=[[ZLNewsMapViewController alloc] initWithNibName:nil bundle:nil];
    analyzeVC.earthquakes=[self.fetchedResultsController fetchedObjects];
    analyzeVC.navigationItem.title=NSLocalizedString(@"distribution", nil);
    [self.navigationController pushViewController:analyzeVC animated:YES];
    [analyzeVC release];
}

-(void)onRefresh
{
    ZLAppDelegate *appDelegate=(ZLAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate onRefreshData];
}

-(void)onTapMapBar
{
    ZLNewsMapViewController *analyzeVC=[[ZLNewsMapViewController alloc] initWithNibName:nil bundle:nil];
    //analyzeVC.earthquakes=[self.fetchedResultsController fetchedObjects];
    //analyzeVC.navigationItem.title=NSLocalizedString(@"distribution", nil);
    [analyzeVC setEarthquakes:[self.fetchedResultsController fetchedObjects]];
    [self.navigationController pushViewController:analyzeVC animated:YES];
    
    [analyzeVC release];
    /*
    ZLNewsMapViewController *mapvc=[self getNewestMapVC];
    if (mapvc) {
        
        if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
            [self presentViewController:mapvc animated:YES completion:nil];
        }else{
            [self presentModalViewController:mapvc animated:YES];
        }
        [mapvc setEarthquakes:[self.fetchedResultsController fetchedObjects]];
    }
     */
}

-(void)setRefreshState:(BOOL)refresh
{
    self.navigationItem.leftBarButtonItem=refresh?activityBar:refreshBar;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = refresh;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.twoWeeksAgo = nil;
    activityBar=nil;
    refreshBar=nil;
    self.searchBar=nil;
    self.searchDc=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.twoWeeksAgo = nil;
    activityBar=nil;
    refreshBar=nil;
    self.searchBar=nil;
    self.searchDc=nil;
}

// On-demand initializer for read-only property.
- (NSDateFormatter *)dateFormatter {
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:[[NSTimeZone localTimeZone] secondsFromGMT]]];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setAMSymbol:NSLocalizedString(@"AM", nil)];
        [dateFormatter setPMSymbol:NSLocalizedString(@"PM", nil)];
        [dateFormatter setDateFormat:NSLocalizedString(@"MMM d, yyyy, h:mm:ss aaa", nil)];
    }
    return dateFormatter;
}

// Based on the magnitude of the earthquake, return an image indicating its seismic strength.
- (UIImage *)imageForMagnitude:(CGFloat)magnitude {
	if (magnitude >= 5.0) {
		return [UIImage imageNamed:@"5.0.png"];
	}
	if (magnitude >= 4.0) {
		return [UIImage imageNamed:@"4.0.png"];
	}
	if (magnitude >= 3.0) {
		return [UIImage imageNamed:@"3.0.png"];
	}
	if (magnitude >= 2.0) {
		return [UIImage imageNamed:@"2.0.png"];
	}
	return nil;
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([[fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    return 0;
}

/*
 //设置分区
 -(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
 
 return 1;
 }
 */

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"productcell";
    ZLProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    //[cell sizeToFit];
    if (!cell) {
    }
    cell.cellDelegate=self;
    cell.tag=100+indexPath.row;
    Earthquake *earthquake=(Earthquake *)[fetchedResultsController objectAtIndexPath:indexPath];
   
    [cell setCellData:earthquake];
    return cell;
}

#pragma mark - collectionView delegate



//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //UIEdgeInsets top = {5,10,15,5};
    UIEdgeInsets top = {10,ZL_TABLEVIEW_LEFTMARGIN,10,ZL_TABLEVIEW_LEFTMARGIN};
    return top;
}

//设置顶部的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={0,0};
    return size;
}
//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //return CGSizeMake(120,130);
    return CGSizeMake(self.view.frame.size.width-2*ZL_TABLEVIEW_LEFTMARGIN,ZL_PRODUCT_CELL_HEIGHT);
    //return CGSizeMake(240,(kDeviceHeight-kNavHeight*2-kTabBarHeight-20)/4.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    Earthquake *earthquake = (Earthquake *)[fetchedResultsController objectAtIndexPath:indexPath];
    ZLMapViewController *mapVC=[[ZLMapViewController alloc] initWithNibName:nil bundle:nil];
    mapVC.theQuake=earthquake;
    mapVC.theDate=[NSString stringWithFormat:@"%@", [self.dateFormatter stringFromDate:earthquake.date]];
    //mapVC.longitude=[earthquake.longitude floatValue];
    //mapVC.latitude=[earthquake.latitude floatValue];
    //mapVC.title=earthquake.location;
    [self.navigationController pushViewController:mapVC animated:YES];
    [mapVC release];
}

#pragma mark -
#pragma mark Core Data

- (NSFetchedResultsController *)fetchedResultsController {
    // Set up the fetched results controller if needed.
    if (fetchedResultsController == nil) {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Earthquake"
                                                  inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                            managedObjectContext:managedObjectContext
                                              sectionNameKeyPath:nil
                                                       cacheName:nil];
        self.fetchedResultsController = aFetchedResultsController;
        
        [aFetchedResultsController release];
        [fetchRequest release];
        [sortDescriptor release];
        [sortDescriptors release];
    }
	
	return fetchedResultsController;
}

-(void)reloadSearchData{
    [searchResults removeAllObjects];
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    isTextChanged=NO;
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Earthquake"
                                              inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    float sf=0.f;
    NSString *st=searchBar.text;
    if(st!=nil&&st.length>0)
    {
       NSPredicate * predicate = [NSPredicate
                     predicateWithFormat:@"SELF matches[c] %@", @"^[1-9].?[0-9]*$"];
        BOOL matchs = [predicate evaluateWithObject:st];
        if (matchs&&[st respondsToSelector:@selector(floatValue)])
        {
            sf=[st floatValue];
            st=[NSString stringWithFormat:@"%.1f",sf];
            if (sf>0)
            {
                fetchRequest.predicate = [NSPredicate predicateWithFormat:@"magnitude >= %@", st];
            }
        }
        else{
            st=[NSString stringWithFormat:@"*%@*",st];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"location like %@", st];
        }
    }
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray *fetchedItems = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if (fetchedItems&&[fetchedItems count]>0)
    {
        [searchResults addObjectsFromArray:fetchedItems];
        
    }
   
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
}
- (NSFetchedResultsController *)fetchedSearchResultsController {
    ZLTRACE(@"");
    // Set up the fetched results controller if needed.
    if (fetchedSearchResultsController == nil||self.searchDc.isActive||isTextChanged) {
        ZLTRACE(@"self.searchDc isActive");
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        isTextChanged=NO;
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Earthquake"
                                                  inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        //float sf=0.f;
        NSString *st=searchBar.text;
        //if (st!=nil&&[st respondsToSelector:@selector(floatValue)])
        if(st!=nil&&st.length>0)
        {
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"location like %@", st];
            /*
             sf=[st floatValue];
             
             ZLTRACE(@"zl :%f",sf);
             if (sf>0)
             {
             fetchRequest.predicate = [NSPredicate predicateWithFormat:@"magnitude > %.1f", sf];
             }
             */
        }
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                            managedObjectContext:managedObjectContext
                                              sectionNameKeyPath:nil
                                                       cacheName:nil];
        self.fetchedSearchResultsController = aFetchedResultsController;
        
        [aFetchedResultsController release];
        [fetchRequest release];
        [sortDescriptor release];
        [sortDescriptors release];
    }
	
	return fetchedSearchResultsController;
}

// this is called from mergeChanges: method,
// requested to be made on the main thread so we can update our table with our new earthquake objects
//
- (void)updateContext:(NSNotification *)notification
{
	NSManagedObjectContext *mainContext = [self managedObjectContext];
	[mainContext mergeChangesFromContextDidSaveNotification:notification];
    
    // keep our number of earthquakes to a manageable level, remove earthquakes older than 2 weeks
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Earthquake"
                                              inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date < %@", self.twoWeeksAgo];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *olderEarthquakes = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    Earthquake *earthquake;
    for (earthquake in olderEarthquakes) {
        [self.managedObjectContext deleteObject:earthquake];
    }
    
    // update our fetched results after the merge
    //
	if (![self.fetchedResultsController performFetch:&error]) {
		// Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate.
        // You should not use this function in a shipping application, although it may be useful
        // during development. If it is not possible to recover from the error, display an alert
        // panel that instructs the user to quit the application by pressing the Home button.
        //
        ZLTRACE(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    [fetchRequest release];
	[mCollectionView reloadData];
}

// this is called via observing "NSManagedObjectContextDidSaveNotification" from our ParseOperation
- (void)mergeChanges:(NSNotification *)notification {
    
    ZLTRACE(@"mergeChanges");
    [self setRefreshState:NO];
	NSManagedObjectContext *mainContext = [self managedObjectContext];
    if ([notification object] == mainContext) {
        // main context save, no need to perform the merge
        return;
    }
    [self performSelectorOnMainThread:@selector(updateContext:) withObject:notification waitUntilDone:YES];
}

#pragma mark - @protocol ZLProductCellDelegate <NSObject>

-(UIImage *)earthquakeCellImageForMagnitude:(float)magnitude
{
    return [self imageForMagnitude:magnitude];
}

-(NSString *)earthquakeCellFormatterDate:(NSDate *)date
{
    return [self.dateFormatter stringFromDate:date];
}

@end

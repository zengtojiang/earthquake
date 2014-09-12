//
//  ZLHomeViewController.m
//  EarthQuake
//
//  Created by mac  on 13-5-12.
//  Copyright (c) 2013年 icow. All rights reserved.
//

#import "ZLHomeViewController.h"
#import "ZLRootViewController.h"

#define ZL_PROMPT_GAP 15

@interface ZLHomeViewController ()

@end

@implementation ZLHomeViewController
@synthesize managedObjectContext, fetchedResultsController, twoWeeksAgo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [fetchedResultsController release];
    [twoWeeksAgo release];
	[managedObjectContext release];
    if (newestMapVC) {
        [newestMapVC release];
    }
    if (attentionVC) {
        [attentionVC release];
    }
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=ZL_BG_COLOR;
    
    
    UIImageView *imageViewLow=[self getLeftImage];
    CGRect originFrame=imageViewLow.frame;
    originFrame.origin.y=60.f;
    imageViewLow.frame=originFrame;
    imageViewLow.image=[UIImage imageNamed:@"green"];
    [self.view addSubview:imageViewLow];
    
    UILabel *lblLow=[self getRightLabel];
    CGRect originValueFrame=lblLow.frame;
    originValueFrame.origin.y=originFrame.origin.y;
    lblLow.text=NSLocalizedString(@"magnitude < 4", nil);
    lblLow.frame=originValueFrame;
    [self.view addSubview:lblLow];
    
    UIImageView *imageViewMid=[self getLeftImage];
    originFrame=imageViewMid.frame;
    originFrame.origin.y= imageViewLow.frame.origin.y+imageViewLow.frame.size.height+ZL_PROMPT_GAP;
    imageViewMid.frame=originFrame;
    imageViewMid.image=[UIImage imageNamed:@"purple"];
    [self.view addSubview:imageViewMid];
    
    UILabel *lblMid=[self getRightLabel];
    originValueFrame=lblMid.frame;
    originValueFrame.origin.y=originFrame.origin.y;
    lblMid.text=NSLocalizedString(@"magnitude 4-7", nil);
    lblMid.frame=originValueFrame;
    [self.view addSubview:lblMid];
    
    UIImageView *imageViewHigh=[self getLeftImage];
    originFrame=imageViewHigh.frame;
    originFrame.origin.y= imageViewMid.frame.origin.y+imageViewMid.frame.size.height+ZL_PROMPT_GAP;
    imageViewHigh.frame=originFrame;
    imageViewHigh.image=[UIImage imageNamed:@"red"];
    [self.view addSubview:imageViewHigh];
    
    UILabel *lblHigh=[self getRightLabel];
    originValueFrame=lblHigh.frame;
    originValueFrame.origin.y=originFrame.origin.y;
    lblHigh.text=NSLocalizedString(@"magnitude > 7", nil);
    lblHigh.frame=originValueFrame;
    [self.view addSubview:lblHigh];
    
    
    
	// Do any additional setup after loading the view.
    UIButton *buttonNews=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonNews.frame=CGRectMake(56, self.view.frame.size.height-40, 32, 20);
    [buttonNews setImage:[UIImage imageNamed:@"latest"] forState:UIControlStateNormal];
    [buttonNews setImage:[UIImage imageNamed:@"latest_down"] forState:UIControlStateHighlighted];
    [self.view addSubview:buttonNews];
    [buttonNews addTarget:self action:@selector(onShowNewest:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonAttention=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonAttention.frame=CGRectMake(144, self.view.frame.size.height-40, 32, 20);
    [buttonAttention setImage:[UIImage imageNamed:@"concern"] forState:UIControlStateNormal];
    [buttonAttention setImage:[UIImage imageNamed:@"concern_down"] forState:UIControlStateHighlighted];
    [self.view addSubview:buttonAttention];
    [buttonAttention addTarget:self action:@selector(onShowAttentions:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonComment=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonComment.frame=CGRectMake(250, self.view.frame.size.height-40, 32, 20);
    [buttonComment setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [buttonComment setImage:[UIImage imageNamed:@"comment_down"] forState:UIControlStateHighlighted];
    [self.view addSubview:buttonComment];
    [buttonComment addTarget:self action:@selector(onComment:) forControlEvents:UIControlEventTouchUpInside];
    
    /*
    
    UIButton *buttonGraph=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonGraph.frame=CGRectMake(220, self.view.frame.size.height-90, 80, 80);
    [buttonGraph setImage:[UIImage imageNamed:@"magquakes"] forState:UIControlStateNormal];
    [buttonGraph setImage:[UIImage imageNamed:@"Brazil"] forState:UIControlStateHighlighted];
    [self.view addSubview:buttonGraph];
    [buttonGraph addTarget:self action:@selector(onShowGraph:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonSetting=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonSetting.frame=CGRectMake(220, self.view.frame.size.height-190, 80, 80);
    [buttonSetting setImage:[UIImage imageNamed:@"Brazil"] forState:UIControlStateNormal];
    [buttonSetting setImage:[UIImage imageNamed:@"Brazil"] forState:UIControlStateHighlighted];
    [self.view addSubview:buttonSetting];
    [buttonSetting addTarget:self action:@selector(onSetting:) forControlEvents:UIControlEventTouchUpInside];
    */
    // compute the date two weeks ago from today, used later when dumping old earthquakes
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:-14];  // 14 days back from today
    self.twoWeeksAgo = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    [offsetComponents release];
    [gregorian release];
    
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
    [self getNewestMapVC];
}


-(UIImageView *)getLeftImage
{
    UIImageView *imageView=[[[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 25.f, 25.f)] autorelease];
    return imageView;
}

-(UILabel *)getRightLabel
{
    UILabel *lblDateTitle=[[[UILabel alloc] initWithFrame:CGRectMake(70, 0, 210, 25.f)] autorelease];
    lblDateTitle.textColor = ZL_TEXT_COLOR;
    lblDateTitle.font=[UIFont systemFontOfSize:18.0f];
    lblDateTitle.shadowColor=[UIColor colorWithRed:56.0/255.0 green:124.0/255.0 blue:0.0/255.0 alpha:1.0];
    lblDateTitle.shadowOffset=CGSizeMake(0, -1);
    lblDateTitle.backgroundColor = [UIColor clearColor];
    if (ZL_IOS6) {
        lblDateTitle.textAlignment=NSTextAlignmentLeft;
        
    }else{
        lblDateTitle.textAlignment=NSTextAlignmentLeft;
    }
    return lblDateTitle;
}

-(ZLNewsMapViewController *)getNewestMapVC{
    if (newestMapVC==nil) {
        newestMapVC=[[ZLNewsMapViewController alloc] initWithNibName:nil bundle:nil];
        newestMapVC.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    }
    return newestMapVC;
}

-(ZLAttentionViewController *)getAttentionVC{
    if (attentionVC==nil) {
        attentionVC=[[ZLAttentionViewController alloc] initWithNibName:nil bundle:nil];
        attentionVC.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    }
    return attentionVC;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)onShowNewest:(id)sender
{
    ZLNewsMapViewController *mapvc=[self getNewestMapVC];
    if (mapvc) {
       
        [self presentViewController:mapvc animated:YES completion:nil];
         [mapvc setEarthquakes:[self.fetchedResultsController fetchedObjects]];
    }
    /*
    ZLAnalizyMapViewController *analyzeVC=[[ZLAnalizyMapViewController alloc] init];
    analyzeVC.earthquakes=[self.fetchedResultsController fetchedObjects];
    analyzeVC.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [self presentViewController:analyzeVC animated:YES completion:nil];
    }else{
        [self presentModalViewController:analyzeVC animated:YES];
    }
    */
    //analyzeVC.navigationItem.title=NSLocalizedString(@"newest infos", nil) ;
    //[self.navigationController pushViewController:analyzeVC animated:YES];
   // [analyzeVC release];
}

-(void)onShowAttentions:(id)sender
{
    ZLAttentionViewController *mapvc=[self getAttentionVC];
    if (mapvc) {
        mapvc.earthquakes=[self.fetchedResultsController fetchedObjects];
         [self presentViewController:mapvc animated:YES completion:nil];
        [mapvc restartVC];
    }
}

-(void)onComment:(id)sender
{
    //ZLRootViewController *mapvc=[[ZLRootViewController alloc] initWithNibName:nil bundle:nil];
   ZLRootViewController *mapvc=[[[ZLRootViewController alloc] init] autorelease];
    mapvc.managedObjectContext = self.managedObjectContext;
    attentionVC.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    if (mapvc) {
       // mapvc.earthquakes=[self.fetchedResultsController fetchedObjects];
       [self presentViewController:mapvc animated:YES completion:nil];
       // [mapvc restartVC];
    }
    [mapvc release];
    /*
    //https://itunes.apple.com/cn/app/de-zhen-zi-xun-tai/id583896783?mt=8
    NSString *commenturl=@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=583896783";
    NSURL *url=[NSURL URLWithString:commenturl];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
     */
}


-(void)onShowGraph:(id)sender
{
    
}

-(void)onSetting:(id)sender
{
    
}

- (NSFetchedResultsController *)fetchedResultsController {
    ZLTRACE(@"");
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
}

// this is called via observing "NSManagedObjectContextDidSaveNotification" from our ParseOperation
- (void)mergeChanges:(NSNotification *)notification {
    
    ZLTRACE(@"mergeChanges");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSManagedObjectContext *mainContext = [self managedObjectContext];
    if ([notification object] == mainContext) {
        // main context save, no need to perform the merge
        return;
    }
    [self performSelectorOnMainThread:@selector(updateContext:) withObject:notification waitUntilDone:YES];
}
@end

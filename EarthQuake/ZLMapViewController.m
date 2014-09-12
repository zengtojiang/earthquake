//
//  ZLMapViewController.m
//  EarthQuake
//
//  Created by mac  on 12-12-2.
//  Copyright (c) 2012年 icow. All rights reserved.
//

#import "ZLMapViewController.h"
#import "ZLMapPinObject.h"
#import "ZLWeiboViewController.h"
#import "ZLComposeViewController.h"
#import "ZLAlertView.h"

@interface ZLMapViewController ()

@end

@implementation ZLMapViewController
@synthesize theQuake;
@synthesize zlMap;
@synthesize theDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init{
    self=[super init];
    if (self) {
       
    }
    return self;
}

-(void)onSinaWeibo{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        ZLTRACE(@"availabel");
        
        SLComposeViewController *scc=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        [scc setInitialText:[NSString stringWithFormat:@"%@%@\n%@%.1f\n%@%@\n%@%@",NSLocalizedString(@"address",nil), theQuake.location,NSLocalizedString(@"magnitude",nil),[theQuake.magnitude floatValue],NSLocalizedString(@"date",nil),theDate,NSLocalizedString(@"link",nil),theQuake.USGSWebLink]];
        [scc setCompletionHandler:^(SLComposeViewControllerResult result){
            NSLog(@"weibo result");
            if (result==SLComposeViewControllerResultDone) {
                ZLTRACE(@"send weibo success");
            }else if(result==SLComposeViewControllerResultCancelled){
                ZLTRACE(@"send weibo cancelled");
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            //ZLTRACE([NSString stringWithFormat:@"weibo result %d",result]);
        }];
        [self presentViewController:scc animated:YES completion:nil];
        
    }else{
        ZLAlertView *alertView=[[ZLAlertView alloc] initWithMessage:NSLocalizedString(@"please set your account first",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) confirmButtonTitles:nil];
        //UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"please set your account first",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

-(void)onFacebook{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        ZLTRACE(@"availabel");
        
        SLComposeViewController *scc=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [scc setInitialText:[NSString stringWithFormat:@"%@%@\n%@%.1f\n%@%@\n%@%@",NSLocalizedString(@"address",nil), theQuake.location,NSLocalizedString(@"magnitude",nil),[theQuake.magnitude floatValue],NSLocalizedString(@"date",nil),theDate,NSLocalizedString(@"link",nil),theQuake.USGSWebLink]];
        [scc setCompletionHandler:^(SLComposeViewControllerResult result){
            NSLog(@"weibo result");
            if (result==SLComposeViewControllerResultDone) {
                ZLTRACE(@"send weibo success");
            }else if(result==SLComposeViewControllerResultCancelled){
                ZLTRACE(@"send weibo cancelled");
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            //ZLTRACE([NSString stringWithFormat:@"weibo result %d",result]);
        }];
        [self presentViewController:scc animated:YES completion:nil];
        
    }else{
        ZLAlertView *alertView=[[ZLAlertView alloc] initWithMessage:NSLocalizedString(@"please set your account first",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) confirmButtonTitles:nil];
        //UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"please set your account first",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (BOOL) canPerformAction:(SEL)selector withSender:(id) sender {
    if (selector == @selector(onSinaWeibo) || selector == @selector(onFacebook)) {
        return YES;
    }
    return NO;
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

-(void)dealloc
{
    self.zlMap=nil;
    [theQuake release];
    [theDate release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=theQuake.location;
    
    //UIBarButtonItem *backBar=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backIcon6.png"] style:UIBarButtonItemStylePlain target:nil action:NULL];
    
     UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
     //[btnBack setTitle:@"Cancel" forState:UIControlStateNormal];
     UIImage *buttonImage=[UIImage imageNamed:@"backIcon6.png"];
     [btnBack setImage:buttonImage forState:UIControlStateNormal];//@"buttonGreen.png"
     btnBack.frame=CGRectMake(0, 0, buttonImage.size.width*0.9, buttonImage.size.height*0.9);
     [btnBack addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *backBar=[[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem=backBar;
    [backBar release];
    
    
    UIButton *btnWeibo=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnWeibo setImage:[UIImage imageNamed:@"compose.png"] forState:UIControlStateNormal];//@"buttonGreen.png"
    btnWeibo.frame=CGRectMake(0, 0, 34, 34);
    [btnWeibo addTarget:self action:@selector(onWeibo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* weiboBar=[[UIBarButtonItem alloc] initWithCustomView:btnWeibo];
   // UIBarButtonItem* weiboBar=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onWeibo:)];
    self.navigationItem.rightBarButtonItem=weiboBar;
    [weiboBar release];
    
   // self.navigationItem.backBarButtonItem.title=NSLocalizedString(@"back", nil);
	// Do any additional setup after loading the view.
    //self.navigationItem.title=NSLocalizedString(@"", <#comment#>) @"";
    self.zlMap=[[[MKMapView alloc] initWithFrame:self.view.bounds] autorelease];
    self.zlMap.showsUserLocation=YES;
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude=[theQuake.latitude floatValue];
    theCoordinate.longitude=[theQuake.longitude floatValue];
    
    MKCoordinateSpan theSpan;
    theSpan.latitudeDelta=1;
    theSpan.longitudeDelta=1;
    
    MKCoordinateRegion theRegion;
    theRegion.center=theCoordinate;
    theRegion.span=theSpan;
    
    self.zlMap.region=theRegion;
    self.zlMap.mapType=MKMapTypeStandard;
    
    [self.view addSubview:self.zlMap];
    
    ZLMapPinObject *pinView=[[ZLMapPinObject alloc] init];
    pinView.coordinate=theCoordinate;
    [self.zlMap addAnnotation:pinView];
    [pinView release];    
}


-(void)onWeibo:(id)barItem{
    ZLComposeViewController *detailVC=[[ZLComposeViewController alloc] initWithNibName:nil bundle:nil];
    detailVC.modalTransitionStyle=UIModalTransitionStylePartialCurl;
    detailVC.earthQuake=self.theQuake;
    [self presentViewController:detailVC animated:YES completion:nil];
    [detailVC release];
    /*
   UIMenuController* theWeiboMenu=[UIMenuController sharedMenuController];
    [theWeiboMenu setMenuItems:[NSArray arrayWithObjects:[[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"send to sina", nil) action:@selector(onSinaWeibo)] autorelease],[[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"send to facebook", nil) action:@selector(onFacebook)] autorelease], nil]];
    [theWeiboMenu setTargetRect:CGRectMake(300, 0, 0, 0) inView:self.view];
    [theWeiboMenu setMenuVisible:YES animated:YES];
     */
    /*
    ZLTRACE(@"");
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        ZLTRACE(@"availabel");
        
        SLComposeViewController *scc=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        [scc setInitialText:[NSString stringWithFormat:@"地震地点：%@\n震级：%.1f\n时间：%@\n链接：%@",theQuake.location,[theQuake.magnitude floatValue],theDate,theQuake.USGSWebLink]];
        [scc setCompletionHandler:^(SLComposeViewControllerResult result){
            NSLog(@"weibo result");
            if (result==SLComposeViewControllerResultDone) {
                ZLTRACE(@"send weibo success");
            }else if(result==SLComposeViewControllerResultCancelled){
                ZLTRACE(@"send weibo cancelled");
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            //ZLTRACE([NSString stringWithFormat:@"weibo result %d",result]);
        }];
        [self presentViewController:scc animated:YES completion:nil];
        
    }else{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"" message:@"请先在\"设置\"中设置您的新浪微博账号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
     */
}

-(void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ZLAnalizyMapViewController.m
//  EarthQuake
//
//  Created by mac  on 13-1-20.
//  Copyright (c) 2013年 icow. All rights reserved.
//

#import "ZLNewsMapViewController.h"
#import "ZLMapPinObject.h"
#import "ZLComposeViewController.h"
#import "HSStretchableButton.h"

#define ZL_PROMPT_GAP 12//15

@interface ZLNewsMapViewController ()

@end

@implementation ZLNewsMapViewController
@synthesize zlMap;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        annotations=[[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

-(void)dealloc{
    [annotations release];
    [zlMap release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.zlMap=[[[MKMapView alloc] initWithFrame:self.view.bounds] autorelease];
    self.zlMap.delegate=self;
    //MKCoordinateRegion worldRegion = MKCoordinateRegionForMapRect(MKMapRectWorld);
    MKCoordinateRegion region = MKCoordinateRegionMake(zlMap.centerCoordinate, MKCoordinateSpanMake(180, 360));
    self.zlMap.showsUserLocation=YES;
    self.zlMap.region=region;
    self.zlMap.mapType=MKMapTypeStandard;
    
    [self.view addSubview:self.zlMap];
   
    [self setNavigationBar];
    /*
    UIToolbar *theToolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, ZLSCREEN_WIDTH, 44)];
    theToolbar.tintColor=ZL_BAR_COLOR;
    [theToolbar setTranslucent:YES];
    UIBarButtonItem *backBar=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(onBack)];
    
    UIBarButtonItem *titleBar=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"distribution", nil) style:UIBarButtonItemStylePlain target:nil action:NULL];
    //titleBar.enabled=NO;
    
    UIBarButtonItem *spaceBar=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    [theToolbar setItems:[NSArray arrayWithObjects:backBar,spaceBar,titleBar,spaceBar, nil]];
    [spaceBar release];
    [backBar release];
    [titleBar release];
    [self.view addSubview:theToolbar];
    [theToolbar release];
     */
    
    if (annotations&&[annotations count]) {
        //ZLTRACE(@"annotation count:%d",[annotations count]);
        [self.zlMap addAnnotations:annotations];
    }
    [self addPromptViews];
}

-(void)setNavigationBar
{
    self.navigationItem.title=NSLocalizedString(@"distribution",nil);
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    //[btnBack setTitle:@"Cancel" forState:UIControlStateNormal];
    UIImage *buttonImage=[UIImage imageNamed:@"backIcon6.png"];
    [btnBack setImage:buttonImage forState:UIControlStateNormal];//@"buttonGreen.png"
    btnBack.frame=CGRectMake(0, 0, buttonImage.size.width*0.9, buttonImage.size.height*0.9);
    [btnBack addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBar=[[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem=backBar;
    [backBar release];
}

-(void)addPromptViews
{
    UIImageView *imageViewLow=[self getLeftImage];
    CGRect originFrame=imageViewLow.frame;
    originFrame.origin.y=ISIOS7?80.f:15;
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
}

-(void)setEarthquakes:(NSArray *)__earthquakes
{
    [annotations removeAllObjects];
    if (__earthquakes) {
        for (int i=0,n=[__earthquakes count]; i<n; i++) {
            Earthquake *earthquake=[__earthquakes objectAtIndex:i];
            CLLocationCoordinate2D theCoordinate;
            theCoordinate.latitude=[earthquake.latitude floatValue];
            theCoordinate.longitude=[earthquake.longitude floatValue];
            
            ZLMapPinObject *pinView=[[ZLMapPinObject alloc] init];
            pinView.coordinate=theCoordinate;
            pinView.earthquake=earthquake;
            pinView.title=earthquake.location;//[NSString stringWithFormat:@"%.f",[earthquake.magnitude floatValue]];
            pinView.magnitude=[earthquake.magnitude floatValue];
           // [self.zlMap addAnnotation:pinView];
            [annotations addObject:pinView];
            [pinView release];
        }
    }
//    if (annotations&&[annotations count]) {
//        ZLTRACE(@"annotation count:%d",[annotations count]);
//        [self.zlMap addAnnotations:annotations];
//    }
}

-(UIImageView *)getLeftImage
{
    UIImageView *imageView=[[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 18.f, 18.f)] autorelease];
    return imageView;
}

-(UILabel *)getRightLabel
{
    UILabel *lblDateTitle=[[[UILabel alloc] initWithFrame:CGRectMake(34, 0, 210, 18.f)] autorelease];
    lblDateTitle.textColor = [UIColor darkGrayColor];
    lblDateTitle.font=[UIFont fontWithName:@"ChalkboardSE-Bold" size:15];
    //lblDateTitle.shadowColor=[UIColor colorWithRed:56.0/255.0 green:124.0/255.0 blue:0.0/255.0 alpha:1.0];
    //lblDateTitle.shadowOffset=CGSizeMake(0, -1);
    lblDateTitle.backgroundColor = [UIColor clearColor];
    lblDateTitle.textAlignment=NSTextAlignmentLeft;
    return lblDateTitle;
}

-(void)onBack
{
    if ([annotations count]) {
        [self.zlMap removeAnnotations:annotations];
    }
    [self.navigationController popViewControllerAnimated:YES];
    /*
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (!annotation||![annotation isKindOfClass:[ZLMapPinObject class]]) {
        NSLog(@"viewForAnnotation error");
        return nil;
    }
    ZLMapPinObject *pinObject=(ZLMapPinObject *)annotation;
    static NSString *annotationIdentifier=@"zlannotationID";
    MKPinAnnotationView *pinView=(MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    if (pinView==nil) {
        pinView=[[[MKPinAnnotationView alloc] initWithAnnotation:pinObject reuseIdentifier:annotationIdentifier] autorelease];
        pinView.canShowCallout=YES;
        pinView.animatesDrop=NO;
        
        HSStretchableButton * btnMap=[HSStretchableButton buttonWithType:UIButtonTypeCustom];
        [btnMap setBackgroundImage:[UIImage imageNamed:@"buttonGreen.png"] forState:UIControlStateNormal];
        [btnMap setBackgroundImage:[UIImage imageNamed:@"buttonGreen_disabled.png"] forState:UIControlStateHighlighted];
        btnMap.frame=CGRectMake(0, 0, 80, 32.f);
        [btnMap stretchImage];
        btnMap.tag=201;
        [btnMap setTitle:NSLocalizedString(@"detail",nil) forState:UIControlStateNormal];
        btnMap.titleLabel.font=[UIFont fontWithName:@"ChalkboardSE-Bold" size:ZL_MIDDLE_FONT_SIZE];
        //btnMap.titleLabel.textAlignment=NSTextAlignmentRight;
        [btnMap setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[btnMap addTarget:self action:@selector(onTapMapBar) forControlEvents:UIControlEventTouchUpInside];
       
        
//        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
//        button.backgroundColor=ZL_BAR_COLOR;//[UIColor colorWithRed:.5 green:.54f blue:.2f alpha:.5];
//        button.tag=201;
//        button.frame=CGRectMake(0, 0, 80, 32.f);
//        [button setTitle:NSLocalizedString(@"detail", nil) forState:UIControlStateNormal];
        pinView.rightCalloutAccessoryView=btnMap;//button;
         
    }
    pinView.annotation=pinObject;
    float magnitude=pinObject.magnitude;
    ZLTRACE(@"magnitude:%f",magnitude);
    if (magnitude<4) {
        pinView.pinColor=MKPinAnnotationColorGreen;
    }else if(magnitude<7){
        pinView.pinColor=MKPinAnnotationColorPurple;
    }else{
        pinView.pinColor=MKPinAnnotationColorRed;
    }
   // pinView.pinColor=MKPinAnnotationColorRed;
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    ZLTRACE(@"");
    ZLMapPinObject *pinObject=(ZLMapPinObject *)view.annotation;
    if (pinObject&&pinObject.earthquake) {
        ZLComposeViewController *detailVC=[[ZLComposeViewController alloc] initWithNibName:nil bundle:nil];
        detailVC.modalTransitionStyle=UIModalTransitionStylePartialCurl;
        detailVC.earthQuake=pinObject.earthquake;
        [self presentViewController:detailVC animated:YES completion:nil];
        [detailVC release];
    }
}
@end

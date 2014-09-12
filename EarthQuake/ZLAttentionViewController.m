//
//  ZLAttentionViewController.m
//  EarthQuake
//
//  Created by mac  on 13-5-12.
//  Copyright (c) 2013年 icow. All rights reserved.
//

#import "ZLAttentionViewController.h"
#import "ZLAttentionAnnotation.h"
#import "ZLEditAttentionViewController.h"
#import "ZLComposeViewController.h"

@interface ZLAttentionViewController ()
//-(void)showActionSheet;
-(void)getAttentionsFromDefaults;
-(void)cleartMapView;
@end

@implementation ZLAttentionViewController
@synthesize earthquakes,zlMap;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        attentionOverlays=[[NSMutableArray alloc] initWithCapacity:3];
        attentionAnnotations=[[NSMutableArray alloc] initWithCapacity:10];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAttentionsChange:) name:ZL_ATTENTIONS_CHANGE_NOTIFICATION object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZL_ATTENTIONS_CHANGE_NOTIFICATION object:nil];
    [attentionOverlays release];
    [earthquakes release];
    [zlMap release];
    if (noAnnotationView) {
        [noAnnotationView release];
    }
    [attentionAnnotations release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    self.zlMap=[[[MKMapView alloc] initWithFrame:self.view.bounds] autorelease];
    self.zlMap.delegate=self;
    //MKCoordinateRegion worldRegion = MKCoordinateRegionForMapRect(MKMapRectWorld);
    MKCoordinateRegion region = MKCoordinateRegionMake(zlMap.centerCoordinate, MKCoordinateSpanMake(180, 360));
    //[mapView setRegion:region animated:YES];
    /*
     CLLocationCoordinate2D theCoordinate;
     theCoordinate.latitude=0;//[theQuake.latitude floatValue];
     theCoordinate.longitude=0;//[theQuake.longitude floatValue];
     
     MKCoordinateSpan theSpan;
     theSpan.latitudeDelta=1;
     theSpan.longitudeDelta=1;
     
     MKCoordinateRegion theRegion;
     theRegion.center=theCoordinate;
     theRegion.span=theSpan;
     
     self.zlMap.region=theRegion;
     */
    self.zlMap.region=region;
    self.zlMap.mapType=MKMapTypeStandard;
    self.zlMap.showsUserLocation=YES;
    [self.view addSubview:self.zlMap];
    
    UIToolbar *theToolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, ZLSCREEN_WIDTH, 44)];
    theToolbar.tag=100;
    theToolbar.tintColor=ZL_BAR_COLOR;
    [theToolbar setTranslucent:YES];
    UIBarButtonItem *backBar=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(onBack)];
    
//    UIBarButtonItem *editBar =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEnterAddAttentionVC:)];
    
    UIBarButtonItem *editBar=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"concern", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(onEnterAddAttentionVC:)];
    
    UIBarButtonItem *titleBar=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"attention region", nil) style:UIBarButtonItemStylePlain target:nil action:NULL];
    //titleBar.enabled=NO;
    
    UIBarButtonItem *spaceBar=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    [theToolbar setItems:[NSArray arrayWithObjects:backBar,spaceBar,titleBar,spaceBar,editBar, nil]];
    [spaceBar release];
    [editBar release];
    [backBar release];
    [titleBar release];
    [self.view addSubview:theToolbar];
    [theToolbar release];
}

-(void)onBack
{
    [self cleartMapView];
    
   [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showNoAnnotationView:(BOOL)show
{
    if (show) {
        if (noAnnotationView==nil) {
            noAnnotationView=[[UIView alloc] initWithFrame:self.view.bounds];
            noAnnotationView.backgroundColor=ZL_BG_COLOR;
            
            UILabel *lblPrompt=[[UILabel alloc] initWithFrame:CGRectMake(70, 180, 180, 60)];
            lblPrompt.backgroundColor=[UIColor clearColor];
            lblPrompt.textColor=ZL_TEXT_COLOR;
            lblPrompt.numberOfLines=0;
            lblPrompt.font=[UIFont boldSystemFontOfSize:15.f];
            lblPrompt.textAlignment=NSTextAlignmentCenter;
            [noAnnotationView addSubview:lblPrompt];
            [lblPrompt release];
            lblPrompt.text=NSLocalizedString(@"no annotation yet", nil);
            
            UIButton *btnPromt=[UIButton buttonWithType:UIButtonTypeCustom];
            btnPromt.frame=CGRectMake(80, 255, 160, 35.f);
            UIImage *imgUp=[UIImage imageNamed:@"btn_green.png"];
            UIImage *imgDown=[UIImage imageNamed:@"btn_green_down.png"];
            if (ZL_IOS5) {
                [btnPromt setBackgroundImage:[imgUp resizableImageWithCapInsets:UIEdgeInsetsMake(5.f, 10.f, 5.f, 10.f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
                [btnPromt setBackgroundImage:[imgDown resizableImageWithCapInsets:UIEdgeInsetsMake(5.f, 10.f, 5.f, 10.f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateHighlighted];
            }else{
                [btnPromt setBackgroundImage:[imgUp stretchableImageWithLeftCapWidth:imgUp.size.width/2 topCapHeight:imgUp.size.height/2] forState:UIControlStateNormal];
                [btnPromt setBackgroundImage:[imgDown  stretchableImageWithLeftCapWidth:imgDown.size.width/2 topCapHeight:imgDown.size.height/2] forState:UIControlStateHighlighted];
            }
            
            UILabel *_lblText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, btnPromt.frame.size.width, btnPromt.frame.size.height)];
            _lblText.textColor = [UIColor whiteColor];
            _lblText.font=[UIFont systemFontOfSize:18.0f];
            _lblText.shadowColor=[UIColor colorWithRed:56.0/255.0 green:124.0/255.0 blue:0.0/255.0 alpha:1.0];
            _lblText.shadowOffset=CGSizeMake(0, -1);
            _lblText.backgroundColor = [UIColor clearColor];
            _lblText.textAlignment=NSTextAlignmentCenter;
            _lblText.text=NSLocalizedString(@"set attentions", nil);
            [btnPromt addSubview:_lblText];
            [_lblText release];
            [btnPromt addTarget:self action:@selector(onEnterAddAttentionVC:) forControlEvents:UIControlEventTouchUpInside];
            
            [noAnnotationView addSubview:btnPromt];
        }
        if (!noAnnotationView.superview) {
            [self.view insertSubview:noAnnotationView belowSubview:[self.view viewWithTag:100]];
        }
    }else{
        if (noAnnotationView&&noAnnotationView.superview) {
            [noAnnotationView removeFromSuperview];
        }
    }
}

-(void)cleartMapView
{
    if ([attentionOverlays count]) {
        [self.zlMap removeOverlays:attentionOverlays];
        [attentionOverlays removeAllObjects];
    }
    if ([attentionAnnotations count]) {
        [self.zlMap removeAnnotations:attentionAnnotations];
        [attentionAnnotations removeAllObjects];
    }
}

-(void)addQuakesAnnotation
{
    if ([attentionOverlays count]) {
        for (int i=0,n=[earthquakes count]; i<n; i++) {
            Earthquake *earthquake=[earthquakes objectAtIndex:i];
            CLLocationCoordinate2D theCoordinate;
            theCoordinate.latitude=[earthquake.latitude floatValue];
            theCoordinate.longitude=[earthquake.longitude floatValue];
            BOOL bInRegion=NO;
            for (MKCircle *circle in attentionOverlays) {
                //ZLTRACE(@"circleRect:%@",MKStringFromMapRect(circle.boundingMapRect));
                if(MKMapRectContainsPoint(circle.boundingMapRect,MKMapPointForCoordinate(theCoordinate))){
                    bInRegion=YES;
                    break;
                }
            }
            if (bInRegion) {
                ZLMapPinObject *pinView=[[ZLMapPinObject alloc] init];
                pinView.earthquake=earthquake;
                pinView.coordinate=theCoordinate;
                pinView.title=earthquake.location;//[NSString stringWithFormat:@"%.f",[earthquake.magnitude floatValue]];
                pinView.magnitude=[earthquake.magnitude floatValue];
                [self.zlMap addAnnotation:pinView];
                [pinView release];
                [attentionAnnotations addObject:pinView];
            }
        }
    }
}

-(void)restartVC
{
    [self getAttentionsFromDefaults];
    
    if ([attentionOverlays count]) {
       [self showNoAnnotationView:NO];
        for (MKCircle *circle in attentionOverlays) {
            [self.zlMap addOverlay:circle];
            [self addQuakesAnnotation];
        }
    }else{
        [self showNoAnnotationView:YES];
    }
}

-(void)onAttentionsChange:(NSNotification *)notification
{
    [self cleartMapView];
    [self restartVC];
}

-(void)getAttentionsFromDefaults
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSArray *annotationData=[userDefaults objectForKey:@"zl_annotations"];
    if (annotationData&&[annotationData isKindOfClass:[NSArray class]]&&[annotationData count]) {
        for (NSDictionary *annotationItem in annotationData) {
            float latitude=[[annotationItem objectForKey:@"lat"] floatValue];
            float longitude=[[annotationItem objectForKey:@"lon"] floatValue];
            float radius=[[annotationItem objectForKey:@"radius"] floatValue];
            
            CLLocationCoordinate2D theCoordinate;
            theCoordinate.latitude=latitude;
            theCoordinate.longitude=longitude;
            
            MKCircle *circleLay=[MKCircle circleWithCenterCoordinate:theCoordinate radius:radius];
            [attentionOverlays addObject:circleLay];
        }
    }
}

-(void)onEnterAddAttentionVC:(id)sender
{
    ZLEditAttentionViewController * attentionVC=[[ZLEditAttentionViewController alloc] initWithNibName:nil bundle:nil];
    attentionVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:attentionVC animated:YES completion:nil];
    [attentionVC release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation) {
        if ([annotation isKindOfClass:[ZLMapPinObject class]]) {
            ZLMapPinObject *pinObject=(ZLMapPinObject *)annotation;
            static NSString *annotationIdentifier=@"zlAnnotation";
            MKPinAnnotationView *pinView=(MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
            if (pinView==nil) {
                pinView=[[[MKPinAnnotationView alloc] initWithAnnotation:pinObject reuseIdentifier:annotationIdentifier] autorelease];
                pinView.canShowCallout=YES;
                pinView.draggable=NO;
                pinView.animatesDrop=NO;
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                button.backgroundColor=ZL_BAR_COLOR;//[UIColor colorWithRed:.5 green:.54f blue:.2f alpha:.5];
                button.tag=201;
                button.frame=CGRectMake(0, 0, 80, 32.f);
                [button setTitle:NSLocalizedString(@"detail", nil) forState:UIControlStateNormal];
                pinView.rightCalloutAccessoryView=button;
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
            return pinView;
        }
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    ZLTRACE(@"latitude:%f longitude:%f",view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    ZLTRACE(@"");
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    ZLTRACE(@"");
    if (overlay) {
        if ([overlay isKindOfClass:[MKCircle class]]) {
            ZLTRACE(@"create CircleView");
            MKCircleView *circleView=[[[MKCircleView alloc] initWithCircle:overlay] autorelease];
            circleView.fillColor=ZL_OVERLAY_COLOR;
            //circleView.strokeColor=[UIColor redColor];
            return circleView;
        }
    }
    return nil;
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

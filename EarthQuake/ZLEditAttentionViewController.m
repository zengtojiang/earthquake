//
//  ZLEditAttentionViewController.m
//  EarthQuake
//
//  Created by mac  on 13-5-13.
//  Copyright (c) 2013年 icow. All rights reserved.
//

#import "ZLEditAttentionViewController.h"
#import "ZLPinAnnotationView.h"
#import "ZLAlertView.h"

@interface ZLEditAttentionViewController ()
-(void)showPromtLbl;
@end

@implementation ZLEditAttentionViewController
@synthesize zlMap;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        annotations=[[NSMutableArray alloc] initWithCapacity:3];
    }
    return self;
}

-(void)dealloc{
    [zlMap release];
    [annotations release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.zlMap=[[[MKMapView alloc] initWithFrame:self.view.bounds] autorelease];
    self.zlMap.delegate=self;
    //MKCoordinateRegion worldRegion = MKCoordinateRegionForMapRect(MKMapRectWorld);
    MKCoordinateRegion region = MKCoordinateRegionMake(zlMap.centerCoordinate, MKCoordinateSpanMake(180, 360));
    self.zlMap.region=region;
    self.zlMap.mapType=MKMapTypeStandard;
    self.zlMap.showsUserLocation=YES;
    [self.view addSubview:self.zlMap];
    /*
	// Do any additional setup after loading the view.
    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame=CGRectMake(20, self.view.frame.size.height-90, 80, 80);
    [buttonBack setImage:[UIImage imageNamed:@"Brazil"] forState:UIControlStateNormal];
    [buttonBack setImage:[UIImage imageNamed:@"Brazil"] forState:UIControlStateHighlighted];
    [self.view addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    */
    [self getAttentionsFromDefaults];
    for (ZLAttentionAnnotation * annotation in annotations) {
        [self.zlMap addAnnotation:annotation];
        [self.zlMap addOverlay:annotation.circle];
    }
    
    UIToolbar *theToolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, ZLSCREEN_WIDTH, 44)];
    theToolbar.tintColor=ZL_BAR_COLOR;
    [theToolbar setTranslucent:YES];
    UIBarButtonItem *backBar=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(onBack)];
    
     UIBarButtonItem *addBar =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAdd)];
    
    UIBarButtonItem *saveBar =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSave)];
    
    UIBarButtonItem *spaceBar=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];

    [theToolbar setItems:[NSArray arrayWithObjects:backBar,spaceBar,addBar,spaceBar,saveBar, nil]];
    [saveBar release];
    [spaceBar release];
    [addBar release];
    [backBar release];
    //titleView=[[ZLTitleView alloc] initWithFrame:CGRectMake(0, ZLSCREEN_HEIGHT-60, mainWidth, 60)];
    [self.view addSubview:theToolbar];
    [theToolbar release];
}

-(void)onBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showPromtLbl
{
    if (lblPrompt==nil) {
        lblPrompt=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width,(self.view.frame.size.height-60)/2, 120, 60)];
        lblPrompt.backgroundColor=ZL_OVERLAY_COLOR;//[UIColor colorWithRed:77.0/255.0 green:55.0/255.0 blue:66.0/255.0 alpha:.8];
        lblPrompt.textColor=[UIColor whiteColor];
        lblPrompt.numberOfLines=1;
        lblPrompt.font=[UIFont boldSystemFontOfSize:15.f];
        lblPrompt.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:lblPrompt];
        [lblPrompt release];
        lblPrompt.text=NSLocalizedString(@"saved success", nil);
    }
    CGRect originFrame=lblPrompt.frame;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDidStopSelector:@selector(hidePromtLbl)];
    originFrame.origin.x=self.view.frame.size.width-120.f;
    lblPrompt.frame=originFrame;
    [UIView commitAnimations];
}

-(void)hidePromtLbl
{
    CGRect originFrame=lblPrompt.frame;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDelay:.8f];
    [UIView setAnimationDuration:.3f];
    originFrame.origin.x=self.view.frame.size.width;
    lblPrompt.frame=originFrame;
    [UIView commitAnimations];
}

-(void)onAdd
{
    ZLAttentionAnnotation *annotation=[[ZLAttentionAnnotation alloc] init];
    //CLLocationCoordinate2D theCoordinate;
    //theCoordinate.latitude=self.zlMap.centerCoordinate;
    //theCoordinate.longitude=110.0f;
    annotation.coordinate=self.zlMap.centerCoordinate;
    annotation.bEditing=YES;
    annotation.radius=100000.f;
    annotation.title=@"|";//NSLocalizedString(@"edit", nil);
    annotation.circle=[MKCircle circleWithCenterCoordinate:annotation.coordinate radius:annotation.radius];
    [self.zlMap addAnnotation:annotation];
    [annotation release];
    [self.zlMap addOverlay:annotation.circle];
    
    [annotations addObject:annotation];
}

-(void)onSave
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    if ([annotations count]) {
        NSMutableArray *localArray=[[NSMutableArray alloc] initWithCapacity:[annotations count]];
        for (ZLAttentionAnnotation *annotationItem in annotations) {
            NSDictionary *annotationDict=[annotationItem dictFromAnnotation];
            if (annotationDict) {
                [localArray addObject:annotationDict];
            }
        }
        [userDefaults setObject:localArray forKey:@"zl_annotations"];
        [localArray release];
    }else{
        [userDefaults removeObjectForKey:@"zl_annotations"];
    }
    [userDefaults synchronize];
    [self showPromtLbl];
    [[NSNotificationCenter defaultCenter] postNotificationName:ZL_ATTENTIONS_CHANGE_NOTIFICATION object:nil];
}

-(void)getAttentionsFromDefaults
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSArray *annotationData=[userDefaults objectForKey:@"zl_annotations"];
    if (annotationData&&[annotationData isKindOfClass:[NSArray class]]&&[annotationData count]) {
        for (NSDictionary *annotationItem in annotationData) {
            
            ZLAttentionAnnotation *annotation=[[ZLAttentionAnnotation alloc] init];
            [annotation setAnnotationData:annotationItem];
            annotation.title=@"|";
            annotation.circle=[MKCircle circleWithCenterCoordinate:annotation.coordinate radius:annotation.radius];
            [annotations addObject:annotation];
            [annotation release];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onDeleteAnnotation
{
    [annotations removeObject:editingAnnotation];
    if (editingAnnotation.circle) {
        [self.zlMap removeOverlay:editingAnnotation.circle];
    }
    [self.zlMap removeAnnotation:editingAnnotation];
}

- (void)radiusChanged:(UITextField *)sender {
    if (sender.hasText) {
        int len=[sender.text length];
        if (len > 2)
        {
            sender.text = [sender.text substringToIndex:2];
        }
    }
}

-(void)onEditAnnotation
{
    
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"edit radius", nil) message:NSLocalizedString(@"max radius is 300km", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"preview", nil), nil];
        
    UITextField *textFild=[[UITextField alloc] initWithFrame:CGRectMake(40, 85.f, 200, 32)];
    textFild.backgroundColor=[UIColor lightTextColor];
    textFild.textColor=[UIColor whiteColor];
    textFild.tag=100;
    textFild.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    textFild.textAlignment=NSTextAlignmentRight;
    textFild.borderStyle=UITextBorderStyleRoundedRect;
    [textFild addTarget:self action:@selector(radiusChanged:) forControlEvents:UIControlEventEditingChanged];
    textFild.text=[NSString stringWithFormat:@"%.f",editingAnnotation.radius/10000];
    //textFild.
    textFild.keyboardType=UIKeyboardTypeNumberPad;
    textFild.font=[UIFont boldSystemFontOfSize:18.f];
    textFild.delegate=self;
    [alertView addSubview:textFild];
    [textFild release];
    
    UILabel *rightPrompt=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 60, 32)];
    rightPrompt.backgroundColor=[UIColor clearColor];
    rightPrompt.textColor=ZL_TEXT_COLOR;//[UIColor whiteColor];
    rightPrompt.font=[UIFont boldSystemFontOfSize:18.f];
    textFild.rightView=rightPrompt;
    textFild.rightViewMode=UITextFieldViewModeAlways;
    rightPrompt.text=NSLocalizedString(@"10km", nil);
    [rightPrompt release];

    
    [alertView show];
    [alertView release];
    [textFild becomeFirstResponder];
     
}

#pragma mark - UIAlertViewDelegate
//- (void)willPresentAlertView:(UIAlertView *)alertView
//{
//    CGRect originFrame=alertView.frame;
//    originFrame.size.height=180.f;
//    alertView.frame=originFrame;
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textField=(UITextField *)[alertView viewWithTag:100];
    if (textField) {
        ZLTRACE(@"buttonIndex:%d",buttonIndex);
        if (buttonIndex==1) {
            
            if (textField.hasText) {
                float radius=[textField.text floatValue]*10000;
                ZLTRACE(@"new radius:%f",radius);
                if (radius>300000) {
                    radius=300000;
                }
                editingAnnotation.radius=radius;
                if (editingAnnotation.circle) {
                    [self.zlMap removeOverlay:editingAnnotation.circle];
                }
                editingAnnotation.circle=[MKCircle circleWithCenterCoordinate:editingAnnotation.coordinate radius:editingAnnotation.radius];
                [self.zlMap addOverlay:editingAnnotation.circle];
            }
        }
       // [textField resignFirstResponder];
    }
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation) {
        if ([annotation isKindOfClass:[ZLAttentionAnnotation class]]) {
            ZLAttentionAnnotation *pinObject=(ZLAttentionAnnotation *)annotation;
            static NSString *annotationIdentifier=@"hzlAttentionAnnotation";
            ZLPinAnnotationView *pinView=(ZLPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
            if (pinView==nil) {
                pinView=[[[ZLPinAnnotationView alloc] initWithAnnotation:pinObject reuseIdentifier:annotationIdentifier] autorelease];
                pinView.canShowCallout=YES;
                pinView.draggable=YES;
            }
            pinView.annotation=pinObject;
            pinView.pinColor=pinObject.bEditing?MKPinAnnotationColorGreen:MKPinAnnotationColorPurple;
            return pinView;
        }
    }
    
    return nil;
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

//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
//{
//    editingAnnotation=view.annotation;
//    ZLTRACE(@"latitude:%f longitude:%f",view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);
//    [self showActionSheet];
//}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    ZLTRACE(@"newState:%d oldState:%d",newState,oldState);
    if (newState==MKAnnotationViewDragStateStarting||(oldState!=MKAnnotationViewDragStateDragging&&newState==MKAnnotationViewDragStateDragging)) {
        ZLAttentionAnnotation *pinObject=(ZLAttentionAnnotation *)view.annotation;
        if (pinObject.circle) {
            [self.zlMap removeOverlay:pinObject.circle];
            pinObject.circle=nil;
        }
    }
    if (newState==MKAnnotationViewDragStateCanceling||newState==MKAnnotationViewDragStateEnding) {
        ZLAttentionAnnotation *pinObject=(ZLAttentionAnnotation *)view.annotation;
        if (pinObject.circle) {
            [self.zlMap removeOverlay:pinObject.circle];
        }
        pinObject.circle=[MKCircle circleWithCenterCoordinate:pinObject.coordinate radius:pinObject.radius];
        [self.zlMap addOverlay:pinObject.circle];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    editingAnnotation=view.annotation;
    ZLTRACE(@"latitude:%f longitude:%f",view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);
    ZLTRACE(@"button tag:%d",control.tag);
    if (control.tag==201) {
        [self onDeleteAnnotation];
    }else if(control.tag==200){
        [self onEditAnnotation];
    }
   // [self showActionSheet];
}
@end

//
//  ZLComposeViewController.m
//  EarthQuake
//
//  Created by mac  on 13-5-13.
//  Copyright (c) 2013年 icow. All rights reserved.
//

#import "ZLComposeViewController.h"
#import "HSStretchableButton.h"
#import "ZLAlertView.h"

@interface ZLComposeViewController ()

@end

#define ZL_LABEL_HEIGHT 32.f

@implementation ZLComposeViewController
@synthesize earthQuake;
@synthesize theDate;

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
    [earthQuake release];
    [theDate release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=ZL_BG_COLOR;
    
    // On-demand initializer for read-only property.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:[[NSTimeZone localTimeZone] secondsFromGMT]]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setAMSymbol:NSLocalizedString(@"AM", nil)];
    [dateFormatter setPMSymbol:NSLocalizedString(@"PM", nil)];
    [dateFormatter setDateFormat:NSLocalizedString(@"MMM d, yyyy, h:mm:ss aaa", nil)];
    self.theDate=[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:earthQuake.date]];
    [dateFormatter release];
    
    
    HSStretchableButton * buttonSina=[HSStretchableButton buttonWithType:UIButtonTypeCustom];
    [buttonSina setBackgroundImage:[UIImage imageNamed:@"buttonGreen.png"] forState:UIControlStateNormal];
    [buttonSina setBackgroundImage:[UIImage imageNamed:@"buttonGreen_disabled.png"] forState:UIControlStateHighlighted];
    buttonSina.frame=CGRectMake(40, self.view.frame.size.height-50, 115, 40);
    [buttonSina stretchImage];
    [buttonSina setTitle:NSLocalizedString(@"send to sina",nil) forState:UIControlStateNormal];
    buttonSina.titleLabel.font=[UIFont fontWithName:@"ChalkboardSE-Bold" size:ZL_MIDDLE_FONT_SIZE];
    [buttonSina setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonSina addTarget:self action:@selector(onSinaWeibo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSina];
    
    /*
    UIButton *buttonSina=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonSina.frame=CGRectMake(40, self.view.frame.size.height-45, 115, 40);
    UIImage *imgUp=[UIImage imageNamed:@"btn_green.png"];
    UIImage *imgDown=[UIImage imageNamed:@"btn_green_down.png"];
    if (ZL_IOS5) {
        [buttonSina setBackgroundImage:[imgUp resizableImageWithCapInsets:UIEdgeInsetsMake(5.f, 10.f, 5.f, 10.f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [buttonSina setBackgroundImage:[imgDown resizableImageWithCapInsets:UIEdgeInsetsMake(5.f, 10.f, 5.f, 10.f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateHighlighted];
    }else{
        [buttonSina setBackgroundImage:[imgUp stretchableImageWithLeftCapWidth:imgUp.size.width/2 topCapHeight:imgUp.size.height/2] forState:UIControlStateNormal];
        [buttonSina setBackgroundImage:[imgDown  stretchableImageWithLeftCapWidth:imgDown.size.width/2 topCapHeight:imgDown.size.height/2] forState:UIControlStateHighlighted];
    }
    
    UILabel *_lblText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, buttonSina.frame.size.width, buttonSina.frame.size.height)];
    _lblText.textColor = [UIColor whiteColor];
    _lblText.font=[UIFont systemFontOfSize:18.0f];
    _lblText.shadowColor=[UIColor colorWithRed:56.0/255.0 green:124.0/255.0 blue:0.0/255.0 alpha:1.0];
    _lblText.shadowOffset=CGSizeMake(0, -1);
    _lblText.backgroundColor = [UIColor clearColor];
     _lblText.textAlignment=NSTextAlignmentCenter;
    _lblText.text=NSLocalizedString(@"send to sina", nil);
    [buttonSina addSubview:_lblText];
    [_lblText release];
    [self.view addSubview:buttonSina];
    [buttonSina addTarget:self action:@selector(onSinaWeibo) forControlEvents:UIControlEventTouchUpInside];
    */
    
    HSStretchableButton * buttonFacebook=[HSStretchableButton buttonWithType:UIButtonTypeCustom];
    [buttonFacebook setBackgroundImage:[UIImage imageNamed:@"buttonRed.png"] forState:UIControlStateNormal];
    [buttonFacebook setBackgroundImage:[UIImage imageNamed:@"buttonRed_disabled.png"] forState:UIControlStateHighlighted];
    buttonFacebook.frame=CGRectMake(170, self.view.frame.size.height-50, 115, 40);
    [buttonFacebook stretchImage];
    [buttonFacebook setTitle:NSLocalizedString(@"send to facebook",nil) forState:UIControlStateNormal];
    buttonFacebook.titleLabel.font=[UIFont fontWithName:@"ChalkboardSE-Bold" size:ZL_MIDDLE_FONT_SIZE];
    [buttonFacebook setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonFacebook addTarget:self action:@selector(onFacebook) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonFacebook];
    
    /*
    UIButton *buttonFacebook=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonFacebook.frame=CGRectMake(170, self.view.frame.size.height-45, 115, 40);
    if (ZL_IOS5) {
        [buttonFacebook setBackgroundImage:[imgUp resizableImageWithCapInsets:UIEdgeInsetsMake(5.f, 10.f, 5.f, 10.f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [buttonFacebook setBackgroundImage:[imgDown resizableImageWithCapInsets:UIEdgeInsetsMake(5.f, 10.f, 5.f, 10.f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateHighlighted];
    }else{
        [buttonFacebook setBackgroundImage:[imgUp stretchableImageWithLeftCapWidth:imgUp.size.width/2 topCapHeight:imgUp.size.height/2] forState:UIControlStateNormal];
        [buttonFacebook setBackgroundImage:[imgDown  stretchableImageWithLeftCapWidth:imgDown.size.width/2 topCapHeight:imgDown.size.height/2] forState:UIControlStateHighlighted];
    }
    
    UILabel *_lblText2=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, buttonFacebook.frame.size.width, buttonFacebook.frame.size.height)];
    _lblText2.textColor = [UIColor whiteColor];
    _lblText2.font=[UIFont systemFontOfSize:18.0f];
    _lblText2.shadowColor=[UIColor colorWithRed:56.0/255.0 green:124.0/255.0 blue:0.0/255.0 alpha:1.0];
    _lblText2.shadowOffset=CGSizeMake(0, -1);
    _lblText2.backgroundColor = [UIColor clearColor];
    _lblText2.textAlignment=NSTextAlignmentCenter;
    _lblText2.text=NSLocalizedString(@"send to facebook", nil);
    [buttonFacebook addSubview:_lblText2];
    [_lblText2 release];
    [self.view addSubview:buttonFacebook];
    [buttonFacebook addTarget:self action:@selector(onFacebook) forControlEvents:UIControlEventTouchUpInside];
    */
    UILabel *lblDateTitle=[self getLeftLabel];
    CGRect originFrame=lblDateTitle.frame;
    originFrame.origin.y=buttonSina.frame.origin.y-ZL_LABEL_HEIGHT-15;
    lblDateTitle.frame=originFrame;
    lblDateTitle.text=NSLocalizedString(@"date", nil);
    [self.view addSubview:lblDateTitle];
    
    UILabel *lblDate=[self getRightLabel];
    lblDate.text=theDate;
    CGRect originValueFrame=lblDate.frame;
    originValueFrame.origin.y=originFrame.origin.y;
    lblDate.frame=originValueFrame;
    [self.view addSubview:lblDate];
    
    UILabel *lblMagTitle=[self getLeftLabel];
    originFrame=lblMagTitle.frame;
    originFrame.origin.y=lblDateTitle.frame.origin.y-ZL_LABEL_HEIGHT;
    lblMagTitle.frame=originFrame;
    lblMagTitle.text=NSLocalizedString(@"magnitude", nil);
    [self.view addSubview:lblMagTitle];
    
    UILabel *lblMag=[self getRightLabel];
    lblMag.text=[NSString stringWithFormat:@"%.1f",[earthQuake.magnitude floatValue]];;
    originValueFrame=lblMag.frame;
    originValueFrame.origin.y=originFrame.origin.y;
    lblMag.frame=originValueFrame;
    [self.view addSubview:lblMag];
    
    UILabel *lblLonTitle=[self getLeftLabel];
    originFrame=lblLonTitle.frame;
    originFrame.origin.y=lblMagTitle.frame.origin.y-ZL_LABEL_HEIGHT;
    lblLonTitle.frame=originFrame;
    lblLonTitle.text=NSLocalizedString(@"longitude", nil);
    [self.view addSubview:lblLonTitle];
    
    UILabel *lblLon=[self getRightLabel];
    lblLon.text=[NSString stringWithFormat:@"%.3f",[earthQuake.longitude floatValue]];
    originValueFrame=lblLon.frame;
    originValueFrame.origin.y=originFrame.origin.y;
    lblLon.frame=originValueFrame;
    [self.view addSubview:lblLon];
    
    UILabel *lblLatTitle=[self getLeftLabel];
    originFrame=lblLatTitle.frame;
    originFrame.origin.y=lblLonTitle.frame.origin.y-ZL_LABEL_HEIGHT;
    lblLatTitle.frame=originFrame;
    lblLatTitle.text=NSLocalizedString(@"latitude", nil);
    [self.view addSubview:lblLatTitle];
    
    UILabel *lblLat=[self getRightLabel];
    lblLat.text=[NSString stringWithFormat:@"%.3f",[earthQuake.latitude floatValue]];
    originValueFrame=lblLat.frame;
    originValueFrame.origin.y=originFrame.origin.y;
    lblLat.frame=originValueFrame;
    [self.view addSubview:lblLat];
    
    UILabel *lblLocTitle=[self getLeftLabel];
    originFrame=lblLocTitle.frame;
    originFrame.origin.y=lblLatTitle.frame.origin.y-ZL_LABEL_HEIGHT;
    lblLocTitle.frame=originFrame;
    lblLocTitle.text=NSLocalizedString(@"address", nil);
    [self.view addSubview:lblLocTitle];
    
    UILabel *lblLoc=[self getRightLabel];
    lblLoc.text=earthQuake.location;
    originValueFrame=lblLoc.frame;
    originValueFrame.origin.y=originFrame.origin.y;
    lblLoc.frame=originValueFrame;
    [self.view addSubview:lblLoc];
    
    
    
}

-(UILabel *)getLeftLabel
{
    UILabel *lblDateTitle=[[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, ZL_LABEL_HEIGHT)] autorelease];
    lblDateTitle.textColor = [UIColor whiteColor];
    lblDateTitle.font=[UIFont systemFontOfSize:15.0f];
    lblDateTitle.shadowColor=[UIColor colorWithRed:56.0/255.0 green:124.0/255.0 blue:0.0/255.0 alpha:1.0];
    lblDateTitle.shadowOffset=CGSizeMake(0, -1);
    lblDateTitle.backgroundColor = [UIColor clearColor];
    if (ZL_IOS6) {
        lblDateTitle.textAlignment=NSTextAlignmentRight;
        
    }else{
        lblDateTitle.textAlignment=NSTextAlignmentRight;
    }
    return lblDateTitle;
}

-(UILabel *)getRightLabel
{
    UILabel *lblDateTitle=[[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 210, ZL_LABEL_HEIGHT)] autorelease];
    lblDateTitle.textColor = [UIColor whiteColor];
    lblDateTitle.font=[UIFont systemFontOfSize:15.0f];
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

-(void)onSinaWeibo{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        ZLTRACE(@"availabel");
        
        SLComposeViewController *scc=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        [scc setInitialText:[NSString stringWithFormat:@"%@%@\n%@%.1f\n%@%@",NSLocalizedString(@"address",nil), earthQuake.location,NSLocalizedString(@"magnitude",nil),[earthQuake.magnitude floatValue],NSLocalizedString(@"date",nil),theDate]];
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
        [scc setInitialText:[NSString stringWithFormat:@"%@%@\n%@%.1f\n%@%@",NSLocalizedString(@"address",nil), earthQuake.location,NSLocalizedString(@"magnitude",nil),[earthQuake.magnitude floatValue],NSLocalizedString(@"date",nil),theDate]];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  HSNavigationController.m
//  HSMCBStandardEdition
//
//  Created by jiangll on 13-8-26.
//  Copyright (c) 2013年 hisunsray. All rights reserved.
//

#import "HSNavigationController.h"

@interface HSNavigationController ()

@end

@implementation HSNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //设置所有UINavigationBar背景
        //[[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.backgroundColor=[UIColor blackColor];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 5.0) {
            if ([self.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
                UIImage *navBarImg = [UIImage imageNamed:@"navi_bg.png"];
                
                [self.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
                
            }
        }else{
            naviBGImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,320, 44)];
            naviBGImageView.backgroundColor=[UIColor blackColor];
            naviBGImageView.image=[UIImage imageNamed:@"navi_bg.png"];
            [self.navigationBar addSubview:naviBGImageView];
            [naviBGImageView release];
        }
        //[self.navigationBar layoutIfNeeded];
    }
    return self;
}

-(void)setCustomLeftNaviBar:(HSNavigationBarButton *)leftBar
{
    if (leftNaviButton) {
        [leftNaviButton removeFromSuperview];
    }
    if (leftBar) {
        //self.leftNaviButton=leftBar;
        [self.navigationBar addSubview:leftBar];
        leftNaviButton=leftBar;
        //        UIBarButtonItem *leftBarButton=[[UIBarButtonItem alloc] initWithCustomView:leftBar];
        //        self.topItem.leftBarButtonItem=leftBarButton;
        //        [leftBarButton release];
    }else{
        leftNaviButton=nil;
        // self.leftNaviButton
        // self.topItem.leftBarButtonItem=nil;
    }
//    if (leftBar) {
//        UIBarButtonItem *leftBarButton=[[UIBarButtonItem alloc] initWithCustomView:leftBar];
//        self.navigationBar.topItem.leftBarButtonItem=leftBarButton;
//        [leftBarButton release];
//    }else{
//        self.navigationBar.topItem.leftBarButtonItem=nil;
//    }
}

-(void)setCustomRightNaviBar:(HSNavigationBarButton *)rightBar
{
    if (rightNaviButton) {
        [rightNaviButton removeFromSuperview];
    }
    if (rightBar) {
        //self.leftNaviButton=leftBar;
        [self.navigationBar addSubview:rightBar];
        rightNaviButton=rightBar;
        //        UIBarButtonItem *leftBarButton=[[UIBarButtonItem alloc] initWithCustomView:leftBar];
        //        self.topItem.leftBarButtonItem=leftBarButton;
        //        [leftBarButton release];
    }else{
        rightNaviButton=nil;
        // self.leftNaviButton
        // self.topItem.leftBarButtonItem=nil;
    }
    
//    if (rightBar) {
//        UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc] initWithCustomView:rightBar];
//        self.navigationBar.topItem.rightBarButtonItem=rightBarButton;
//        [rightBarButton release];
//    }else{
//        self.navigationBar.topItem.rightBarButtonItem=nil;
//    }
}

//添加自定义视图到导航栏
-(void)addCustomNaviView:(UIView *)cusView
{
    if (customView) {
        [customView removeFromSuperview];
    }
    if (cusView) {
        [self.navigationBar addSubview:cusView];
        customView=cusView;
    }else{
        customView=nil;
    }
}

-(HSNavigationBarButton *)getCustomLeftNaviBar
{
    return leftNaviButton;
}

-(HSNavigationBarButton *)getCustomRightNaviBar
{
    return rightNaviButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (BOOL)wantsFullScreenLayout {
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

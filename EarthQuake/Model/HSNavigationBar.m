//
//  HSNavigationBar.m
//  HSMCBStandardEdition
//
//  Created by jiangll on 13-8-26.
//  Copyright (c) 2013年 hisunsray. All rights reserved.
//

#import "HSNavigationBar.h"

@implementation HSNavigationBarButton


-(void)setLeftNavigationBar:(BOOL)left
{
    [self setBackgroundImage:[UIImage imageNamed:@"navibar_highlighted"] forState:UIControlStateHighlighted];
    UIImageView *imvLine=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navibar_line"]];
    CGRect rFrame=self.frame;
    if (left) {
        imvLine.frame=CGRectMake(rFrame.size.width-1.0f, 0, 1.0f, rFrame.size.height);
    }else{
        imvLine.frame=CGRectMake(0, 0, 1.0f, rFrame.size.height);
    }
    [self addSubview:imvLine];
    [imvLine release];
}

@end

@interface HSNavigationBar()
//@property(nonatomic,retain)HSNavigationBarButton *leftNaviButton;
//@property(nonatomic,retain)HSNavigationBarButton *rightNaviButton;

@end

@implementation HSNavigationBar
//@synthesize leftNaviButton,rightNaviButton;
@synthesize lblTitle;

- (void)dealloc
{
    self.lblTitle=nil;
    
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame andCustomImage:(UIImage *)image
{
    frame.size.height +=IOS7_STATUSBAR_DELTA;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor blackColor];
        if (image) {
            bgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, IOS7_STATUSBAR_DELTA, frame.size.width, frame.size.height-IOS7_STATUSBAR_DELTA)];
            bgImageView.image=image;
            bgImageView.backgroundColor=[UIColor blackColor];
            [self addSubview:bgImageView];
            [bgImageView release];
//            if ([[UIDevice currentDevice].systemVersion floatValue] >= 5.0) {
//                if ([self respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
//                    [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//                    
//                }
//            }else{
//                bgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//                bgImageView.image=image;
//                bgImageView.backgroundColor=[UIColor blackColor];
//                [self addSubview:bgImageView];
//                [bgImageView release];
//            }
        }
        [self createTitleView];
    }
    
    return self;
}

-(void)setTitle:(NSString *)title
{
    if (lblTitle&&title) {
        self.lblTitle.text=title;
    }
}

-(void)createTitleView
{
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(60,IOS7_STATUSBAR_DELTA,SCREEN_WIDTH-120,44) ];
   //CGRectMake(60,IOS7_STATUSBAR_DELTA,161,44)
    title.textAlignment= NSTextAlignmentCenter;
    title.font=[UIFont systemFontOfSize:20];//[UIFont systemFontOfSize:20];
    title.adjustsFontSizeToFitWidth=YES;
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[UIColor whiteColor];
    self.lblTitle=title;
    [self addSubview:title];
    [title release];
}

-(void)setCustomLeftNaviBar:(HSNavigationBarButton *)leftBar
{
    if (leftNaviButton) {
        [leftNaviButton removeFromSuperview];
    }
    if (leftBar) {
        //self.leftNaviButton=leftBar;
        if (ISIOS7) {
            CGRect leftBarFrame=leftBar.frame;
            leftBarFrame.origin.y +=HS_STATUSBAR_HEIGHT;
            leftBar.frame=leftBarFrame;
        }
        leftBar.imageEdgeInsets=UIEdgeInsetsMake(0.0, (60-47.5f)/2, 0.0, (60-47.5f)/2);
        [self addSubview:leftBar];
        leftNaviButton=leftBar;
//        UIBarButtonItem *leftBarButton=[[UIBarButtonItem alloc] initWithCustomView:leftBar];
//        self.topItem.leftBarButtonItem=leftBarButton;
//        [leftBarButton release];
    }else{
        //decwang20131011修正设置按钮为nil时的处理方式
        leftNaviButton = nil;
       // self.leftNaviButton
       // self.topItem.leftBarButtonItem=nil;
    }
}

-(void)setCustomRightNaviBar:(HSNavigationBarButton *)rightBar
{
    if (rightNaviButton) {
        [rightNaviButton removeFromSuperview];
    }
    if (rightBar) {
        if (ISIOS7){
            CGRect rightBarFrame=rightBar.frame;
            rightBarFrame.origin.y +=HS_STATUSBAR_HEIGHT;
            rightBar.frame=rightBarFrame;
        }
        
        rightBar.imageEdgeInsets=UIEdgeInsetsMake(0.0, (60-47.5f)/2, 0.0, (60-47.5f)/2);
        //self.leftNaviButton=leftBar;
        [self addSubview:rightBar];
        rightNaviButton=rightBar;
        //        UIBarButtonItem *leftBarButton=[[UIBarButtonItem alloc] initWithCustomView:leftBar];
        //        self.topItem.leftBarButtonItem=leftBarButton;
        //        [leftBarButton release];
    }else{
        rightNaviButton = nil;
        // self.leftNaviButton
        // self.topItem.leftBarButtonItem=nil;
    }
//    if (rightBar) {
//        UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc] initWithCustomView:rightBar];
//        self.topItem.rightBarButtonItem=rightBarButton;
//        [rightBarButton release];
//    }else{
//        self.topItem.rightBarButtonItem=nil;
//    }
}

//添加自定义视图到导航栏
-(void)addCustomNaviView:(UIView *)cusView
{
    if (customView) {
        [customView removeFromSuperview];
    }
    if (cusView) {
        if (ISIOS7) {
            CGRect customViewFrame=cusView.frame;
            customViewFrame.origin.y +=HS_STATUSBAR_HEIGHT;
            cusView.frame=customViewFrame;
        }
        [self addSubview:cusView];
        customView=cusView;
    }else{
        customView=nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

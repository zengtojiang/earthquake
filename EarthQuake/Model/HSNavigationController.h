//
//  HSNavigationController.h
//  HSMCBStandardEdition
//
//  Created by jiangll on 13-8-26.
//  Copyright (c) 2013年 hisunsray. All rights reserved.
//
/**
 自定义导航栏背景的NavigationController
 */
#import <UIKit/UIKit.h>
#import "HSNavigationBar.h"

@interface HSNavigationController : UINavigationController
{
    UIImageView *naviBGImageView;
    HSNavigationBarButton *leftNaviButton;
    HSNavigationBarButton *rightNaviButton;
    UIView                *customView;
}

//添加左按钮视图到导航栏
-(void)setCustomLeftNaviBar:(HSNavigationBarButton *)leftBar;
//添加右按钮视图到导航栏
-(void)setCustomRightNaviBar:(HSNavigationBarButton *)rightBar;
//添加自定义视图到导航栏
-(void)addCustomNaviView:(UIView *)customView;

-(HSNavigationBarButton *)getCustomLeftNaviBar;
-(HSNavigationBarButton *)getCustomRightNaviBar;
@end

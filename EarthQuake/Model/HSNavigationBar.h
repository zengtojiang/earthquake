//
//  HSNavigationBar.h
//  HSMCBStandardEdition
//
//  Created by jiangll on 13-8-26.
//  Copyright (c) 2013年 hisunsray. All rights reserved.
//
/**
 自定义背景的NavigationBar
 */
#import <UIKit/UIKit.h>

@interface HSNavigationBarButton : UIButton

-(void)setLeftNavigationBar:(BOOL)left;

@end

@interface HSNavigationBar : UIView
{
    UIImageView *bgImageView;
    HSNavigationBarButton *leftNaviButton;
    HSNavigationBarButton *rightNaviButton;
    UIView                *customView;

}
//设置导航栏标题
@property (nonatomic,retain)UILabel *lblTitle;

-(void)setTitle:(NSString *)title;

-(id)initWithFrame:(CGRect)frame andCustomImage:(UIImage *)image;
//添加左按钮视图到导航栏
-(void)setCustomLeftNaviBar:(HSNavigationBarButton *)leftBar;
//添加右按钮视图到导航栏
-(void)setCustomRightNaviBar:(HSNavigationBarButton *)rightBar;

//添加自定义视图到导航栏
-(void)addCustomNaviView:(UIView *)customView;
@end




//
//  ZLPinAnnotationView.m
//  EarthQuake
//
//  Created by mac  on 13-5-13.
//  Copyright (c) 2013年 icow. All rights reserved.
//

#import "ZLPinAnnotationView.h"

@implementation ZLPinAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(UIView *)leftCalloutAccessoryView{
    ZLTRACE(@"");
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor=[UIColor clearColor];
    button.tag=200;
    button.frame=CGRectMake(0, 0, 80, 32.f);
    [button setTitle:NSLocalizedString(@"edit", nil) forState:UIControlStateNormal];
    return button;
}

-(UIView *)rightCalloutAccessoryView{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor=[UIColor clearColor];
    button.tag=201;
    button.frame=CGRectMake(0, 0, 80, 32.f);
    [button setTitle:NSLocalizedString(@"delete", nil) forState:UIControlStateNormal];
    return button;
}

@end

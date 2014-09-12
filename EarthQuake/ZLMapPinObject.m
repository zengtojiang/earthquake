//
//  ZLMapPinObject.m
//  EarthQuake
//
//  Created by mac  on 12-12-2.
//  Copyright (c) 2012年 icow. All rights reserved.
//

#import "ZLMapPinObject.h"

@implementation ZLMapPinObject
@synthesize coordinate;
@synthesize title;
@synthesize magnitude;
@synthesize earthquake;
//@synthesize title;
-(void)dealloc
{
    //[title release];
    [super dealloc];
}
@end

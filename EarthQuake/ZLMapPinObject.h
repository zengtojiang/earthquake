//
//  ZLMapPinObject.h
//  EarthQuake
//
//  Created by mac  on 12-12-2.
//  Copyright (c) 2012年 icow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Earthquake.h"

@interface ZLMapPinObject : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
}
@property(nonatomic,assign)CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property(nonatomic,assign)float magnitude;
@property(nonatomic,retain)Earthquake *earthquake;
@end

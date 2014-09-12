//
//  ZLEarthquake.m
//  EarthQuake
//
//  Created by libs on 14-4-19.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLEarthquake.h"

@implementation ZLEarthquake
@dynamic magnitude;
@dynamic location;
@dynamic date;
@dynamic USGSWebLink;
@dynamic latitude;
@dynamic longitude;

- (void)dealloc {
    self.magnitude=nil;
    self.location=nil;
    self.date=nil;
    self.USGSWebLink=nil;
    self.latitude=nil;
    self.longitude=nil;
    [super dealloc];
}
@end

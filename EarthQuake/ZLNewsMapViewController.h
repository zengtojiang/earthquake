//
//  ZLAnalizyMapViewController.h
//  EarthQuake
//
//  Created by mac  on 13-1-20.
//  Copyright (c) 2013年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Earthquake.h"

@interface ZLNewsMapViewController : UIViewController<MKMapViewDelegate>
{
    NSMutableArray *annotations;
    MKMapView *zlMap;
}
@property(nonatomic,retain)MKMapView *zlMap;
-(void)setEarthquakes:(NSArray *)__earthquakes;
@end

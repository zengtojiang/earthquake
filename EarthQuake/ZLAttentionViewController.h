//
//  ZLAttentionViewController.h
//  EarthQuake
//
//  Created by mac  on 13-5-12.
//  Copyright (c) 2013年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Earthquake.h"
#import "ZLMapPinObject.h"
#import "ZLAttentionAnnotation.h"

@interface ZLAttentionViewController : UIViewController<MKMapViewDelegate>
{
    NSArray *earthquakes;
    MKMapView *zlMap;

    NSMutableArray *attentionOverlays;
    
    NSMutableArray *attentionAnnotations;
    //没有annotation提示页
    UIView *noAnnotationView;
}
@property(nonatomic,retain)MKMapView *zlMap;
@property (nonatomic, retain)NSArray *earthquakes;
-(void)restartVC;
@end

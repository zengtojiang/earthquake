//
//  ZLMapViewController.h
//  EarthQuake
//
//  Created by mac  on 12-12-2.
//  Copyright (c) 2012年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "Earthquake.h"

@interface ZLMapViewController : UIViewController
{
    MKMapView *zlMap;
    //float longitude;
    //float latitude;
    Earthquake *theQuake;
    NSString   *theDate;
    //UIMenuController *theWeiboMenu;
}
@property(nonatomic,retain)MKMapView *zlMap;
@property(nonatomic,retain)Earthquake *theQuake;
@property(nonatomic,copy)NSString *theDate;
//@property(nonatomic,assign)float longitude;
//@property(nonatomic,assign)float latitude;
@end

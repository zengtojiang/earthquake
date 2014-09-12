//
//  ZLComposeViewController.h
//  EarthQuake
//
//  Created by mac  on 13-5-13.
//  Copyright (c) 2013年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Earthquake.h"
#import <Social/Social.h>

@interface ZLComposeViewController : UIViewController
{
    Earthquake *earthQuake;
    NSString   *theDate;
}
@property(nonatomic,retain)Earthquake *earthQuake;
@property(nonatomic,retain)NSString   *theDate;
@end

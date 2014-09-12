//
//  ZLEditAttentionViewController.h
//  EarthQuake
//
//  Created by mac  on 13-5-13.
//  Copyright (c) 2013年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLAttentionAnnotation.h"

@interface ZLEditAttentionViewController : UIViewController<MKMapViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    MKMapView *zlMap;
    ZLAttentionAnnotation *editingAnnotation;
    NSMutableArray *annotations;
    
    UILabel *lblPrompt;
}
@property(nonatomic,retain)MKMapView *zlMap;

@end

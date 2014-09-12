//
//  ZLAttentionAnnotation.h
//  EarthQuake
//
//  Created by mac  on 13-5-12.
//  Copyright (c) 2013年 icow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLAttentionAnnotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
}
@property(nonatomic,assign)CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property(nonatomic,assign)BOOL bEditing;
@property(nonatomic,assign)float radius;
@property(nonatomic,assign)MKCircle *circle;

-(NSDictionary *)dictFromAnnotation;

-(void)setAnnotationData:(NSDictionary *)dict;

@end

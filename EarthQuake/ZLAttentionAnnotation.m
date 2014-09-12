//
//  ZLAttentionAnnotation.m
//  EarthQuake
//
//  Created by mac  on 13-5-12.
//  Copyright (c) 2013年 icow. All rights reserved.
//

#import "ZLAttentionAnnotation.h"

@implementation ZLAttentionAnnotation
@synthesize coordinate;
@synthesize title;
@synthesize bEditing;
@synthesize radius;
@synthesize circle;

-(NSDictionary *)dictFromAnnotation
{
    if (!title) {
        title=@"";
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:coordinate.latitude],@"lat",
            [NSNumber numberWithFloat:coordinate.longitude],@"lon",
            [NSNumber numberWithFloat:radius],@"radius",
            title,@"title",nil];
}

-(void)setAnnotationData:(NSDictionary *)dict
{
    if (dict) {
        float latitude=[[dict objectForKey:@"lat"] floatValue];
        float longitude=[[dict objectForKey:@"lon"] floatValue];
        float __radius=[[dict objectForKey:@"radius"] floatValue];
        NSString *__title=[dict objectForKey:@"title"];
        
        CLLocationCoordinate2D theCoordinate;
        theCoordinate.latitude=latitude;
        theCoordinate.longitude=longitude;
        self.coordinate=theCoordinate;
        self.radius=__radius;
        self.bEditing=NO;
        self.title=__title;
    }
    
}
@end

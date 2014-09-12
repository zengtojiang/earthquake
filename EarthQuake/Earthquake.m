/*
 */

#import "Earthquake.h"

@implementation Earthquake

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

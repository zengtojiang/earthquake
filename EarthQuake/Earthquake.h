/*
 
 */

#import <Foundation/Foundation.h>

@interface Earthquake : NSManagedObject {
    // Magnitude of the earthquake on the Richter scale.
    NSNumber *magnitude;
    
    // Name of the location of the earthquake.
    NSString *location;
    
    // Date and time at which the earthquake occurred.
    NSDate *date;
    
    // Holds the URL to the USGS web page of the earthquake.
    // The application uses this URL to open that page in Safari.
    NSURL *USGSWebLink;
    
    // Latitude and longitude of the earthquake. These properties are not displayed by the
    // application, but are used to create a URL for opening the Maps application. They could
    // alternatively be used in conjuction with MapKit to be shown in a map view.
    NSNumber *latitude;
    NSNumber *longitude;
}

@property (nonatomic, retain) NSNumber *magnitude;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, copy) NSString *USGSWebLink;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;

@end

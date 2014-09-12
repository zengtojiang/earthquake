/*
 
 */

extern NSString *kAddEarthquakesNotif;
extern NSString *kEarthquakeResultsKey;

extern NSString *kEarthquakesErrorNotif;
extern NSString *kEarthquakesMsgErrorKey;

@class Earthquake;

@interface ParseOperation : NSOperation {
    NSData *earthquakeData;

@private
    NSDateFormatter *dateFormatter;
    
    // these variables are used during parsing
    Earthquake *currentEarthquakeObject;
    NSMutableString *currentParsedCharacterData;
    
    BOOL accumulatingParsedCharacterData;
    BOOL didAbortParsing;
    NSUInteger parsedEarthquakesCounter;
    
    NSManagedObjectContext *managedObjectContext;
}

@property (copy, readonly) NSData *earthquakeData;

@property (retain) NSManagedObjectContext *managedObjectContext;
- (id)initWithData:(NSData *)parseData;
@end

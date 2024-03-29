/*
 
 */

#import "ParseOperation.h"
#import "Earthquake.h"
#import "ZLAppDelegate.h"
#import <CoreLocation/CoreLocation.h>

// NSNotification name for sending earthquake data back to the app delegate
NSString *kAddEarthquakesNotif = @"AddEarthquakesNotif";

// NSNotification userInfo key for obtaining the earthquake data
NSString *kEarthquakeResultsKey = @"EarthquakeResultsKey";

// NSNotification name for reporting errors
NSString *kEarthquakesErrorNotif = @"EarthquakeErrorNotif";

// NSNotification userInfo key for obtaining the error message
NSString *kEarthquakesMsgErrorKey = @"EarthquakesMsgErrorKey";


@interface ParseOperation () <NSXMLParserDelegate>
{
    CLGeocoder *geoCoder;
}
    @property (nonatomic, retain) Earthquake *currentEarthquakeObject;
    @property (nonatomic, retain) NSMutableArray *currentParseBatch;
    @property (nonatomic, retain) NSMutableString *currentParsedCharacterData;

-(void)reverseLocation:(Earthquake *)item;
@end

@implementation ParseOperation

@synthesize earthquakeData, currentEarthquakeObject, currentParsedCharacterData, currentParseBatch, managedObjectContext;

- (id)initWithData:(NSData *)parseData
{
    if (self = [super init]) {    
        earthquakeData = [parseData copy];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
        [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        
        // setup our Core Data scratch pad and persistent store
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [self.managedObjectContext setUndoManager:nil];
        
        ZLAppDelegate *appDelegate = (ZLAppDelegate *)[[UIApplication sharedApplication] delegate];
        [self.managedObjectContext setPersistentStoreCoordinator:appDelegate.persistentStoreCoordinator];
        
        parsedEarthquakesCounter = 0;
        geoCoder=[[CLGeocoder alloc] init];
    }
    return self;
}

int num=0;
-(void)reverseLocation:(Earthquake *)item{
    if (num>0) {
        return;
    }
    num++;
    //NSLog(@"latitude:%f longitude:%f",[item.latitude doubleValue],[item.longitude doubleValue]);
    CLLocation *location=[[CLLocation alloc] initWithLatitude:[item.latitude doubleValue] longitude:[item.longitude doubleValue]];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks, NSError* error){
        //NSLog(@"abc:%@",placemarks);
        if (placemarks!=nil&&placemarks.count>0) {
            CLPlacemark *placemark=[placemarks objectAtIndex:0];
            NSLog(@"placemark:%@ locality:%@",placemark.addressDictionary,placemark.locality);
           // NSDictionary *addressDict=[placemark addressDictionary];
            if (placemark.locality!=nil) {
                item.location=placemark.locality;
            }
        }
    }];
    [location release];
}

// a batch of earthquakes are ready to be added
- (void)addEarthquakesToList:(NSArray *)earthquakes {
    assert([NSThread isMainThread]);

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"Earthquake" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = ent;
   
    // narrow the fetch to these two properties
    fetchRequest.propertiesToFetch = [NSArray arrayWithObjects:@"location", @"date", nil];
    
    // before adding the earthquake, first check if there's a duplicate in the backing store
    NSError *error = nil;
    Earthquake *earthquake = nil;
    for (earthquake in earthquakes) {
        if (earthquake==nil||earthquake.location==nil) {
            continue;
        }
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"location = %@ AND date = %@", earthquake.location, earthquake.date];
        
        NSArray *fetchedItems = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedItems.count == 0) {
            //[self reverseLocation:earthquake];
            // we found no duplicate earthquakes, so insert this new one
            [self.managedObjectContext insertObject:earthquake];
        }
    }

    [fetchRequest release];
    
    if (![managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate.
        // You should not use this function in a shipping application, although it may be useful
        // during development. If it is not possible to recover from the error, display an alert
        // panel that instructs the user to quit the application by pressing the Home button.
        //
        ZLTRACE(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}
     
// the main function for this NSOperation, to start the parsing
- (void)main {
    self.currentParseBatch = [NSMutableArray array];
    self.currentParsedCharacterData = [NSMutableString string];
    
    // It's also possible to have NSXMLParser download the data, by passing it a URL, but this is
    // not desirable because it gives less control over the network, particularly in responding to
    // connection errors.
    //
    NSString *str=[[NSString alloc] initWithData:self.earthquakeData encoding:NSUTF8StringEncoding];
    ZLTRACE(@"data  #####:%@",str);
    [str release];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.earthquakeData];
    [parser setDelegate:self];
    [parser parse];
    
    // depending on the total number of earthquakes parsed, the last batch might not have been a
    // "full" batch, and thus not been part of the regular batch transfer. So, we check the count of
    // the array and, if necessary, send it to the main thread.
    //
    // first check if the operation has been cancelled, proceed if not
    //
    if (![self isCancelled]) {
        if ([self.currentParseBatch count] > 0) {
        [self performSelectorOnMainThread:@selector(addEarthquakesToList:)
                               withObject:self.currentParseBatch
                            waitUntilDone:NO];
        }
    }
    
    self.currentParseBatch = nil;
    self.currentEarthquakeObject = nil;
    self.currentParsedCharacterData = nil;
    
    [parser release];
}

- (void)dealloc {
    [earthquakeData release];
    [geoCoder release];
    [currentEarthquakeObject release];
    [currentParsedCharacterData release];
    [currentParseBatch release];
    [dateFormatter release];
    
    [managedObjectContext release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Parser constants

// Limit the number of parsed earthquakes to 100
// (a given day may have more than 100 earthquakes around the world, so we only take the first 100)
//
static const NSUInteger kMaximumNumberOfEarthquakesToParse = 100;

// When an Earthquake object has been fully constructed, it must be passed to the main thread and
// the table view in RootViewController must be reloaded to display it. It is not efficient to do
// this for every Earthquake object - the overhead in communicating between the threads and reloading
// the table exceed the benefit to the user. Instead, we pass the objects in batches, sized by the
// constant below. In your application, the optimal batch size will vary 
// depending on the amount of data in the object and other factors, as appropriate.
//
static NSUInteger const kSizeOfEarthquakeBatch = 20;

// Reduce potential parsing errors by using string constants declared in a single place.
static NSString * const kEntryElementName = @"entry";
static NSString * const kLinkElementName = @"link";
static NSString * const kTitleElementName = @"title";
static NSString * const kUpdatedElementName = @"updated";
static NSString * const kGeoRSSPointElementName = @"georss:point";


#pragma mark -
#pragma mark NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
                                        namespaceURI:(NSString *)namespaceURI
                                       qualifiedName:(NSString *)qName
                                          attributes:(NSDictionary *)attributeDict {
    // If the number of parsed earthquakes is greater than
    // kMaximumNumberOfEarthquakesToParse, abort the parse.
    //
    if (parsedEarthquakesCounter >= kMaximumNumberOfEarthquakesToParse) {
        // Use the flag didAbortParsing to distinguish between this deliberate stop
        // and other parser errors.
        //
        didAbortParsing = YES;
        [parser abortParsing];
    }
    if ([elementName isEqualToString:kEntryElementName]) {
        // insert new earthquake entities as we discover them
        NSEntityDescription *ent = [NSEntityDescription entityForName:@"Earthquake" inManagedObjectContext:self.managedObjectContext];
        
        // create an earthquake managed object, but don't insert it in our moc yet
        Earthquake *earthquake = [[Earthquake alloc] initWithEntity:ent insertIntoManagedObjectContext:nil];  
        self.currentEarthquakeObject = earthquake;
        [earthquake release];
        
    } else if ([elementName isEqualToString:kLinkElementName]) {
        NSString *relAttribute = [attributeDict valueForKey:@"rel"];
        if ([relAttribute isEqualToString:@"alternate"]) {
            NSString *USGSWebLink = [attributeDict valueForKey:@"href"];
            self.currentEarthquakeObject.USGSWebLink = USGSWebLink;
        }
    } else if ([elementName isEqualToString:kTitleElementName] ||
               [elementName isEqualToString:kUpdatedElementName] ||
               [elementName isEqualToString:kGeoRSSPointElementName]) {
        // For the 'title', 'updated', or 'georss:point' element begin accumulating parsed character data.
        // The contents are collected in parser:foundCharacters:.
        accumulatingParsedCharacterData = YES;
        // The mutable string needs to be reset to empty.
        [currentParsedCharacterData setString:@""];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
                                      namespaceURI:(NSString *)namespaceURI
                                     qualifiedName:(NSString *)qName {     
    if ([elementName isEqualToString:kEntryElementName]) {
        // note: we keep a temporary array of managed objects while we are parsing.
        // We do this to avoid inserting objects into our moc ahead of time, just in case we find duplicate earthquakes
        [self.currentParseBatch addObject:self.currentEarthquakeObject];
        
        parsedEarthquakesCounter++;
        if ([self.currentParseBatch count] >= kMaximumNumberOfEarthquakesToParse) {
            [self performSelectorOnMainThread:@selector(addEarthquakesToList:)
                                   withObject:self.currentParseBatch
                                waitUntilDone:NO];
            self.currentParseBatch = [NSMutableArray array];
        }

    } else if ([elementName isEqualToString:kTitleElementName]) {
        // The title element contains the magnitude and location in the following format:
        // <title>M 3.6, Virgin Islands region<title/>
        // Extract the magnitude and the location using a scanner:
        NSScanner *scanner = [NSScanner scannerWithString:self.currentParsedCharacterData];
        // Scan past the "M " before the magnitude.
        if ([scanner scanString:@"M " intoString:NULL]) {
            CGFloat magnitude;
            if ([scanner scanFloat:&magnitude]) {
                self.currentEarthquakeObject.magnitude = [NSNumber numberWithFloat:magnitude];
                // Scan past the ", " before the title.
                if ([scanner scanString:@", " intoString:NULL]) {
                    NSString *location = nil;
                    // Scan the remainer of the string.
                    if ([scanner scanUpToCharactersFromSet:
                         [NSCharacterSet illegalCharacterSet] intoString:&location]) {
                        self.currentEarthquakeObject.location = location;
                    }
                }
            }
        }
    } else if ([elementName isEqualToString:kUpdatedElementName]) {
        if (self.currentEarthquakeObject != nil) {
            self.currentEarthquakeObject.date =
            [dateFormatter dateFromString:self.currentParsedCharacterData];
        }
        else {
            // kUpdatedElementName can be found outside an entry element (i.e. in the XML header)
            // so don't process it here.
        }
    } else if ([elementName isEqualToString:kGeoRSSPointElementName]) {
        // The georss:point element contains the latitude and longitude of the earthquake epicenter.
        // 18.6477 -66.7452
        //
        NSScanner *scanner = [NSScanner scannerWithString:self.currentParsedCharacterData];
        double latitude, longitude;
        if ([scanner scanDouble:&latitude]) {
            if ([scanner scanDouble:&longitude]) {
                self.currentEarthquakeObject.latitude = [NSNumber numberWithDouble:latitude];
                self.currentEarthquakeObject.longitude = [NSNumber numberWithDouble:longitude];
            }
        }
    }
    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    accumulatingParsedCharacterData = NO;
}

// This method is called by the parser when it find parsed character data ("PCDATA") in an element.
// The parser is not guaranteed to deliver all of the parsed character data for an element in a single
// invocation, so it is necessary to accumulate character data until the end of the element is reached.
//
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (accumulatingParsedCharacterData) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        //
        [self.currentParsedCharacterData appendString:string];
    }
}

// an error occurred while parsing the earthquake data,
// post the error as an NSNotification to our app delegate.
// 
- (void)handleEarthquakesError:(NSError *)parseError {
    [[NSNotificationCenter defaultCenter] postNotificationName:kEarthquakesErrorNotif
                                                    object:self
                                                  userInfo:[NSDictionary dictionaryWithObject:parseError
                                                                                       forKey:kEarthquakesMsgErrorKey]];
}

// an error occurred while parsing the earthquake data,
// pass the error to the main thread for handling.
// (note: don't report an error if we aborted the parse due to a max limit of earthquakes)
//
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if ([parseError code] != NSXMLParserDelegateAbortedParseError && !didAbortParsing)
    {
        [self performSelectorOnMainThread:@selector(handleEarthquakesError:)
                               withObject:parseError
                            waitUntilDone:NO];
    }
}

@end

#import "LocationManager.h"

@interface LocationManager () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (copy, nonatomic) LocationUpdateCompletionBlock completionBlock;

@end

@implementation LocationManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.delegate = self;
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        
    }
    return self;
}



+ (instancetype)sharedInstance
{
    
    static LocationManager *location = nil;
    if ([CLLocationManager locationServicesEnabled]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            location = [LocationManager new];
        });
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Permisson denied"
                                                        message:@"Please go to Settings and turn on Location Service for this app."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    
    
    
    
    return location;
}

- (void)startUpdatingLocationWithCompletionBlock:(LocationUpdateCompletionBlock)block
{
    self.completionBlock = block;
    [self.locationManager startUpdatingLocation];
}


@end

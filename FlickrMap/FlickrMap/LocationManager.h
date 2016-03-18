#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

typedef void(^LocationUpdateCompletionBlock)(CLLocation *location, NSError *error);


@interface LocationManager : NSObject

+ (instancetype)sharedInstance;

- (void)startUpdatingLocationWithCompletionBlock:(LocationUpdateCompletionBlock)block;

@end

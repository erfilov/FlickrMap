#import <Foundation/Foundation.h>
#import "LocationManager.h"
@class SessionManager;

typedef void(^CompletionBlock)(NSDictionary *result, NSError *error);

@interface FlickrAPI : NSObject

@property (strong, nonatomic) SessionManager *sessionManager;

- (void)loadImagesFromLocationBL:(CLLocationCoordinate2D)bottomLeft
                    toLocationTR:(CLLocationCoordinate2D)topRight
             withCompletionBlock:(CompletionBlock)completionBlock;

- (void)requestWithText:(NSString *)text
    withCompletionBlock:(CompletionBlock)completionBlock;

@end

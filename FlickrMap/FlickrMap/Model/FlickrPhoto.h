#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FlickrPhoto : NSObject
@property (strong, nonatomic) CLLocation *location;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *thumbnailImageUrl; //100 on longest side
@end

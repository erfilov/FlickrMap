#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FlickrPhoto : NSObject
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *photoID;
@property (copy, nonatomic) NSString *thumbImageUrl;
@property (strong, nonatomic) UIImage *cashedThumbImage;
@property (copy, nonatomic) NSString *bigImageURL;
@property (strong, nonatomic) UIImage *cashedBigImage;

@end

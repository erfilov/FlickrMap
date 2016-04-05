#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FlickrPhoto : NSObject <MKAnnotation>

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *photoID;
@property (copy, nonatomic) NSString *thumbImageUrl;
@property (strong, nonatomic) UIImage *cashedThumbImage;
@property (copy, nonatomic) NSString *bigImageURL;
@property (strong, nonatomic) UIImage *cashedBigImage;
@property (strong, nonatomic) NSDictionary *author;
@property (strong, nonatomic) NSDictionary *exif;

- (instancetype)initValuesFromDictionary:(NSDictionary *)dictionary;

@end

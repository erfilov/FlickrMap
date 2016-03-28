#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class FlickrPhoto;


@interface FlickrPhotoMapAnnotation : NSObject <MKAnnotation>
@property (strong, nonatomic) FlickrPhoto *photo;



@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSString *thumbImageUrl;
@property (strong, nonatomic) UIImage *cashedThumbImage;
@property (copy, nonatomic) NSString * bigImageURL;
@property (strong, nonatomic) UIImage *cashedBigImage;


- (instancetype)initValuesFromDictionary:(NSDictionary *)dictionary;

@end

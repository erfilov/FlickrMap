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
//CR :
// Author is powerful enough to be a separate class, but not just a dictionary
// calls like [self.photo.author valueForKey:@"author_name"]; seems very bad.
// at least all author's keys should be moved to constants and described somewhere
// (but this is not a solution too, just use new class).
@property (strong, nonatomic) NSDictionary *author;
//CR : same for exif
@property (strong, nonatomic) NSDictionary *exif;

- (instancetype)initValuesFromDictionary:(NSDictionary *)dictionary;

@end

#import <UIKit/UIKit.h>
@class FlickrPhotoMapAnnotation;

@interface MapViewVC : UIViewController
@property (strong, nonatomic) FlickrPhotoMapAnnotation * selectedFlickrPhoto;

- (void)generateMapAnnotationsForEntries:(NSDictionary *)entries;
@end

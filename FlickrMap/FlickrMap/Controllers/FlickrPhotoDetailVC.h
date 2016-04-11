#import <UIKit/UIKit.h>
@class FlickrPhoto;

@interface FlickrPhotoDetailVC : UIViewController
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) FlickrPhoto *photo;
@property (strong, nonatomic) NSDictionary<NSString *, FlickrPhoto*> *photos;
@property (assign, nonatomic) NSInteger cellIndex;

@end

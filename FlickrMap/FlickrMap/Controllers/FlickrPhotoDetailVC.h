#import <UIKit/UIKit.h>
@class FlickrPhoto;
@class SessionManager;

@interface FlickrPhotoDetailVC : UIViewController
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) FlickrPhoto *photo;
@property (strong, nonatomic) SessionManager *sessionManager;

@end

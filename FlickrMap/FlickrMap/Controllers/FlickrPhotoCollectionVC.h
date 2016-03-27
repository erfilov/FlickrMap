#import <UIKit/UIKit.h>
@class FlickrPhoto;
@class SessionManager;

@interface FlickrPhotoCollectionVC : UICollectionViewController
@property (copy, nonatomic) NSArray<FlickrPhoto *> *photos;
@property (strong, nonatomic) SessionManager *sessionManager;
@property (copy, nonatomic) NSString *titleNavController;
@end

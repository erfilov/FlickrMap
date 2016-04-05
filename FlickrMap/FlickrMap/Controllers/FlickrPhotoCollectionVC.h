#import <UIKit/UIKit.h>
@class FlickrPhoto;
@class SessionManager;
@class FlickrAPI;

@interface FlickrPhotoCollectionVC : UICollectionViewController
@property (copy, nonatomic) NSArray<FlickrPhoto *> *photos;
@property (strong, nonatomic) SessionManager *sessionManager;
@property (copy, nonatomic) NSString *titleNavController;
@property (strong, nonatomic) FlickrAPI *flickrAPI;
@end

#import <UIKit/UIKit.h>
@class FlickrPhoto;
@class FlickrAPI;

@interface FlickrPhotoCollectionVC : UICollectionViewController
@property (copy, nonatomic) NSArray<FlickrPhoto *> *photos;
@property (copy, nonatomic) NSString *titleNavController;
@property (strong, nonatomic) FlickrAPI *flickrAPI;
@end

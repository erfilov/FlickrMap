#import <UIKit/UIKit.h>
@class FlickrPhoto;

@interface FlickrPhotoCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) FlickrPhoto *photo;

- (void)setImageUrl:(NSURL *)imageURL;

@end

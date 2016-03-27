#import "FlickrPhotoCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation FlickrPhotoCollectionViewCell


- (void)setImageUrl:(NSURL *)imageURL
{
    [self.imageView setImageWithURL:imageURL];
}

@end

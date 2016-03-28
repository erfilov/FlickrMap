#import "FlickrPhotoMapAnnotation.h"
#import "UIImageView+AFNetworking.h"
#import "FlickrPhoto.h"

@implementation FlickrPhotoMapAnnotation

- (instancetype)initValuesFromDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        self.photo = [[FlickrPhoto alloc] init];
        float latitude = [dictionary[@"latitude"] floatValue];
        float longitude = [dictionary[@"longitude"] floatValue];
        self.photo.coordinate = self.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        self.photo.title = self.title = dictionary[@"title"];
        
        
        if (dictionary[@"url_t"]) {
            self.photo.thumbImageUrl = self.thumbImageUrl = dictionary[@"url_t"];
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setImageWithURL:[NSURL URLWithString:self.thumbImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
            self.photo.cashedThumbImage = self.cashedThumbImage = imageView.image;
        }
        
        self.photo.bigImageURL = self.bigImageURL = dictionary[@"url_m"];

    }
    return self;

}

    






@end

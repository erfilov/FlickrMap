#import "FlickrPhoto.h"
#import "UIImageView+AFNetworking.h"

@implementation FlickrPhoto

- (instancetype)initValuesFromDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        float latitude = [dictionary[@"latitude"] floatValue];
        float longitude = [dictionary[@"longitude"] floatValue];
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        self.title = dictionary[@"title"];
        
        
        if (dictionary[@"url_q"]) {
            self.thumbImageUrl = dictionary[@"url_q"];
            UIImageView *imageView = [[UIImageView alloc] init];
            
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.thumbImageUrl]];
            
            self.cashedThumbImage = [UIImage imageNamed:@"placeholder-image"];
            
            [imageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"placeholder-image"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                
                self.cashedThumbImage = image;
                
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                NSLog(@"error %@", [error localizedDescription]);
            }];
        }
        
        self.bigImageURL = dictionary[@"url_m"];
        
        self.photoID = dictionary[@"id"];
        
    }
    return self;
    
}

@end

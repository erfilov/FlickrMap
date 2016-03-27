#import "FlickrPhotoMapAnnotation.h"
#import "SessionManager.h"

@implementation FlickrPhotoMapAnnotation

- (instancetype)initValuesFromDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        
        float latitude = [dictionary[@"latitude"] floatValue];
        float longitude = [dictionary[@"longitude"] floatValue];
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        self.title = dictionary[@"title"];
        
        if (dictionary[@"url_t"]) {
            self.thumbImageUrl = dictionary[@"url_t"];
            
            [[SessionManager sharedManager] loadImageFromURL:self.thumbImageUrl withCompletionBlock:^(UIImage *image, NSError *error) {
                
                self.cashedThumbImage = image;
            
            }];
        
        }
        
        if (!self.cashedThumbImage) {
            self.cashedThumbImage = [UIImage imageNamed:@"unknown_image"];
        
        }
        
        self.bigImageURL = dictionary[@"url_m"];

    }
    return self;

}

    






@end

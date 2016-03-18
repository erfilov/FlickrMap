#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>


static NSString *const kFlickrAPIKey                    = @"99ebbf2885ed731a2dbed15ab554771a";
//static NSString *const secret = @"0727051505b5afb1";
static NSString *const kFlickrBaseRESTURL               = @"https://api.flickr.com/services/rest/?method=";
static NSString *const kFlickrPhotosFlickrSearchMethod  = @"flickr.photos.search";
static NSString *const kFlickrJSONFormat                = @"format=json";
static NSString *const kFlickrApiKeyParameter           = @"api_key";
static NSString *const kFlickrLatitudeParameter         = @"lat=";
static NSString *const kFlickrLongitudeParameter        = @"lon=";
static NSString *const kFlickrBoundingBoxParameter      = @"bbox";
static NSString *const kPhotosFlickrExtras              = @"extras=geo,url_t,url_o,url_m";
static NSString *const kPhotosRadiusParameter           = @"radius=";
static NSString *const kFlickrPhotosRadiusUnitParameter = @"radius_units=km";
static NSString *const kFlickrPerPageParameter          = @"per_page=";
static NSString *const kFlickrPhotosMaxPhotosToRetrieve = @"100";
static NSString *const kFlickrPhotosResponseParamPhotos = @"photos";
static NSString *const kFlickrPhotosResponseParamPhoto  = @"photo";
static NSString *const kFlickrPhotosFlickrNoJSONCallback = @"nojsoncallback=1";



@interface ViewController ()
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    self.sessionManager = [AFHTTPSessionManager manager];
    [self request];
}



- (void)request
{
    NSString *text = @"beauty";


    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@&%@&%@=%@&%@&%@%@&%@&text=nature",
                           kFlickrBaseRESTURL,
                           kFlickrPhotosFlickrSearchMethod,
                           kFlickrJSONFormat,
                           kFlickrApiKeyParameter,
                           kFlickrAPIKey,
                           kPhotosFlickrExtras,
                           kFlickrPerPageParameter,
                           kFlickrPhotosMaxPhotosToRetrieve,
                           kFlickrPhotosFlickrNoJSONCallback];
    
    NSLog(@"%@", urlString);
    
    __block NSError *error = nil;
    
    
   
    
    [self.sessionManager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
   
    

    
    
    
}




@end

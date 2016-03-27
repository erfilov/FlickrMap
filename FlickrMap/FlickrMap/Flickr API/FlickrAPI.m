#import "FlickrAPI.h"
#import "LocationManager.h"
#import "SessionManager.h"
#import "FlickrPhotoMapAnnotation.h"


static NSString *const kFlickrAPIKey                        = @"99ebbf2885ed731a2dbed15ab554771a";
static NSString *const kFlickrBaseRESTURL                   = @"https://api.flickr.com/services/rest/?method=";
static NSString *const kFlickrPhotosSearchMethod            = @"flickr.photos.search";
static NSString *const kFlickrJSONFormat                    = @"format=json";
static NSString *const kFlickrApiKeyParameter               = @"api_key";
static NSString *const kFlickrLatitudeParameter             = @"lat=";
static NSString *const kFlickrLongitudeParameter            = @"lon=";
static NSString *const kFlickrBoundingBoxParameter          = @"bbox";
static NSString *const kFlickrPhotosExtras                  = @"extras=geo,url_t,url_o,url_m";
static NSString *const kFlickrPhotosRadiusParameter         = @"radius=";
static NSString *const kFlickrPhotosRadiusUnitParameter     = @"radius_units=km";
static NSString *const kFlickrPerPageParameter              = @"per_page=";
static NSString *const kFlickrPhotosMaxPhotosToRetrieve     = @"500";
static NSString *const kFlickrPhotoHasGeoParameter          = @"has_geo=";
static NSString *const kFlickrPhotoHasGeoEnable             = @"1";
static NSString *const kFlickrPhotosResponseParamPhotos     = @"photos";
static NSString *const kFlickrPhotosResponseParamPhoto      = @"photo";
static NSString *const kFlickrPhotosFlickrNoJSONCallback    = @"nojsoncallback=1";


@interface FlickrAPI ()
@end



@implementation FlickrAPI

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionManager = [SessionManager sharedManager];
    }
    return self;
}

#pragma mark - Methods

- (void)loadImagesFromLocationBL:(CLLocationCoordinate2D)bottomLeft
                    toLocationTR:(CLLocationCoordinate2D)topRight
             withCompletionBlock:(CompletionBlock)completionBlock

{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@&%@&%@=%@&%@=%f,%f,%f,%f&%@&%@%@&%@%@&%@",
                           kFlickrBaseRESTURL,
                           kFlickrPhotosSearchMethod,
                           kFlickrJSONFormat,
                           kFlickrApiKeyParameter, kFlickrAPIKey,
                           kFlickrBoundingBoxParameter,
                           bottomLeft.longitude, bottomLeft.latitude, topRight.longitude, topRight.latitude,
                           kFlickrPhotosExtras,
                           kFlickrPerPageParameter, kFlickrPhotosMaxPhotosToRetrieve,
                           kFlickrPhotoHasGeoParameter, kFlickrPhotoHasGeoEnable,
                           kFlickrPhotosFlickrNoJSONCallback];
    
    NSLog(@"%@", urlString);
    
    [self.sessionManager.manager GET:urlString
                          parameters:nil
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                  
                                  if (responseObject != nil) {
                                      completionBlock(responseObject, nil);
                                  }
                                  
                              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                  NSLog(@"Error: %@", error);
                                  completionBlock(nil, error);
                              }];
    
}

- (void)requestWithText:(NSString *)text
    withCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@&%@&%@=%@&%@&%@%@&%@%@&%@&text=%@",
                           kFlickrBaseRESTURL,
                           kFlickrPhotosSearchMethod,
                           kFlickrJSONFormat,
                           kFlickrApiKeyParameter,
                           kFlickrAPIKey,
                           kFlickrPhotosExtras,
                           kFlickrPerPageParameter,
                           kFlickrPhotosMaxPhotosToRetrieve,
                           kFlickrPhotoHasGeoParameter, kFlickrPhotoHasGeoEnable,
                           kFlickrPhotosFlickrNoJSONCallback,
                           text];
    
    
    
//FlickrPhotoCollectionVC *photoCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FlickrPhotoCollectionVC"];
    
    
    
    [self.sessionManager.manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        if (responseObject != nil) {
            completionBlock(responseObject, nil);
        }
        
        //NSLog(@"responseObject - %@", responseObject);
        
        
        //photoCollectionVC.photos = [self generateArrayUrlFromResponseObject:responseObject];
        
        //[self.navigationController pushViewController:photoCollectionVC animated:YES];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock(nil, error);
    }];
}






@end

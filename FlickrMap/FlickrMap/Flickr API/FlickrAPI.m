#import "FlickrAPI.h"
#import "LocationManager.h"
#import <AFHTTPSessionManager.h>
#import "FlickrPhoto.h"


static NSString *const kFlickrAPIKey                        = @"99ebbf2885ed731a2dbed15ab554771a";
static NSString *const kFlickrBaseRESTURL                   = @"https://api.flickr.com/services/rest/?method=";
static NSString *const kFlickrPhotosSearchMethod            = @"flickr.photos.search";
static NSString *const kFlickrPhotosGetExifMethod           = @"flickr.photos.getExif";
static NSString *const kFlickrPhotosGetInfoMethod           = @"flickr.photos.getInfo";
static NSString *const kFlickrJSONFormat                    = @"format=json";
static NSString *const kFlickrApiKeyParameter               = @"api_key";
static NSString *const kFlickrLatitudeParameter             = @"lat=";
static NSString *const kFlickrLongitudeParameter            = @"lon=";
static NSString *const kFlickrBoundingBoxParameter          = @"bbox";
static NSString *const kFlickrPhotosExtras                  = @"extras=geo,url_t,url_o,url_m,url_s,url_q";
static NSString *const kFlickrPhotosRadiusParameter         = @"radius=";
static NSString *const kFlickrPhotosRadiusUnitParameter     = @"radius_units=km";
static NSString *const kFlickrPhotoIDParameter              = @"photo_id";
static NSString *const kFlickrPerPageParameter              = @"per_page=";
static NSString *const kFlickrPhotosMaxPhotosToRetrieve     = @"250";
static NSString *const kFlickrPhotosMaxPhotosForMap         = @"100";
static NSString *const kFlickrPhotoHasGeoParameter          = @"has_geo=";
static NSString *const kFlickrPhotoHasGeoEnable             = @"1";
static NSString *const kFlickrPhotosResponseParamPhotos     = @"photos";
static NSString *const kFlickrPhotosResponseParamPhoto      = @"photo";
static NSString *const kFlickrPhotosFlickrNoJSONCallback    = @"nojsoncallback=1";


@interface FlickrAPI ()
@property (strong, nonnull) AFHTTPSessionManager *sessionManager;
@end



@implementation FlickrAPI

#pragma mark - Object lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionManager = [AFHTTPSessionManager manager];
    }
    return self;
}

#pragma mark - Methods

- (void)loadImagesFromLocationBL:(CLLocationCoordinate2D)bottomLeft
                    toLocationTR:(CLLocationCoordinate2D)topRight
             withCompletionBlock:(CompletionBlock)completionBlock

{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@&%@&%@=%@&%@=%f,%f,%f,%f&%@&%@%@&%@",
                           kFlickrBaseRESTURL,
                           kFlickrPhotosSearchMethod,
                           kFlickrJSONFormat,
                           kFlickrApiKeyParameter, kFlickrAPIKey,
                           kFlickrBoundingBoxParameter,
                           bottomLeft.longitude, bottomLeft.latitude, topRight.longitude, topRight.latitude,
                           kFlickrPhotosExtras,
                           kFlickrPerPageParameter, kFlickrPhotosMaxPhotosForMap,
                           kFlickrPhotosFlickrNoJSONCallback];
    
    [self.sessionManager GET:urlString
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
    page:(NSInteger)pageNumber
    withCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@&%@&%@=%@&%@&%@%@&%@%@&%@&page=%ld&text=%@",
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
                           (long)pageNumber,
                           text];
    
    [self.sessionManager GET:urlString
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionTask *task, id responseObject) {
                         if (responseObject != nil) {
                             completionBlock(responseObject, nil);
                         }
                     } failure:^(NSURLSessionTask *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                         completionBlock(nil, error);
                     }];
}

- (void)loadInfoForPhotoID:(NSString *)photoID
    withCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@&%@&%@=%@&%@=%@&%@",
                           kFlickrBaseRESTURL,
                           kFlickrPhotosGetInfoMethod,
                           kFlickrJSONFormat,
                           kFlickrApiKeyParameter,
                           kFlickrAPIKey,
                           kFlickrPhotoIDParameter,
                           photoID,
                           kFlickrPhotosFlickrNoJSONCallback];
    
    
    
    [self.sessionManager GET:urlString
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionTask *task, id responseObject) {
                         if (responseObject != nil) {
                             completionBlock(responseObject, nil);
                         }
                     } failure:^(NSURLSessionTask *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                         completionBlock(nil, error);
                     }];
}

- (void)loadExifForPhotoID:(NSString *)photoID
     withCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@&%@&%@=%@&%@=%@&%@",
                           kFlickrBaseRESTURL,
                           kFlickrPhotosGetExifMethod,
                           kFlickrJSONFormat,
                           kFlickrApiKeyParameter,
                           kFlickrAPIKey,
                           kFlickrPhotoIDParameter,
                           photoID,
                           kFlickrPhotosFlickrNoJSONCallback];
    
    
    [self.sessionManager GET:urlString
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionTask *task, id responseObject) {
                         if (responseObject != nil) {
                             completionBlock(responseObject, nil);
                         }
                     } failure:^(NSURLSessionTask *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                         completionBlock(nil, error);
                     }];

}


- (NSArray *)generateArrayUrlFromResponseObject:(NSDictionary *)responseObject
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSDictionary *dict = responseObject[@"photos"];
    NSArray *photos = dict[@"photo"];
    
    [photos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj != nil) {
            FlickrPhoto *photo = [[FlickrPhoto alloc] init];
            photo.thumbImageUrl = obj[@"url_q"];
            photo.bigImageURL = obj[@"url_m"];
            photo.title = obj[@"title"];
            float latitude = [obj[@"latitude"] floatValue];
            float longitude = [obj[@"longitude"] floatValue];
            photo.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
            photo.photoID = obj[@"id"];
            
            [result addObject:photo];
        }
        
        
    }];
    
    return result;
}


@end

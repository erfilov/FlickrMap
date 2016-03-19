#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "LocationManager.h"
#import "ImageTableVC.h"
#import "FlickrPhoto.h"


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



@interface ViewController () <UITextFieldDelegate>
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
- (IBAction)actionSearch:(UIButton *)sender;
@property (copy, nonatomic) NSString *searchText;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[LocationManager sharedInstance]
        startUpdatingLocationWithCompletionBlock:^(CLLocation *location, NSError *error) {

            NSLog(@"location - %@", location);
        
    }];

    
    self.sessionManager = [AFHTTPSessionManager manager];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.searchTextField) {
        [self.searchTextField resignFirstResponder];
        [self requestWithText:self.searchTextField.text];
    }
    return NO;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@", string);
    return YES;
}

- (void)requestWithText:(NSString *)text
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@&%@&%@=%@&%@&%@%@&%@&text=%@",
                           kFlickrBaseRESTURL,
                           kFlickrPhotosFlickrSearchMethod,
                           kFlickrJSONFormat,
                           kFlickrApiKeyParameter,
                           kFlickrAPIKey,
                           kPhotosFlickrExtras,
                           kFlickrPerPageParameter,
                           kFlickrPhotosMaxPhotosToRetrieve,
                           kFlickrPhotosFlickrNoJSONCallback,
                           text];
    
    
    
    ImageTableVC *imageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageTableVC"];

    [self.sessionManager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSLog(@"responseObject - %@", responseObject);
        imageVC.images = [self generateArrayUrlFromResponseObject:responseObject];
        NSLog(@"%@", imageVC.images);
        [self presentViewController:imageVC animated:YES completion:NULL];
    
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (NSArray *)generateArrayUrlFromResponseObject:(id)responseObject
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSDictionary *dict = responseObject[@"photos"];
    NSArray *photos = dict[@"photo"];
    
    
    [photos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj != nil) {
            FlickrPhoto *photo = [[FlickrPhoto alloc] init];
            photo.thumbnailImageUrl = obj[@"url_t"];
            photo.title = obj[@"title"];
            
            [result addObject:photo];
        }
        
        
    }];
    
    return result;
}



- (IBAction)actionSearch:(UIButton *)sender {
    [self requestWithText:self.searchTextField.text];
}
@end

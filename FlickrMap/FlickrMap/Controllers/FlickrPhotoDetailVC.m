#import "FlickrPhotoDetailVC.h"
#import "UIImage+Blur.h"
#import "LoadingView.h"
#import "SessionManager.h"
#import "FlickrPhoto.h"
#import "UIImageView+AFNetworking.h"
#import "FlickrAPI.h"
#import "AboutPhotoVC.h"


#define kExposureTime       @"ExposureTime"
#define kAperture           @"FNumber"
#define kISO                @"ISO"
#define kFlash              @"Flash"
#define kFocalLength        @"FocalLength"
#define kLensModel          @"LensModel"
#define kCameraModel        @"camera"


@interface FlickrPhotoDetailVC ()
@property (strong, nonatomic) IBOutlet UIImageView *fullScreenImage;
@property (strong, nonatomic) LoadingView *loadingView;
@property (strong, nonatomic) UIImageView *tempImageView;
@property (strong, nonatomic) FlickrAPI *flickrAPI;



@end



@implementation FlickrPhotoDetailVC


#pragma mark - Object lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.flickrAPI = [[FlickrAPI alloc] init];
    self.loadingView = [[LoadingView alloc] init];
    UIImage *blurImage = [[UIImage alloc] init];
    self.fullScreenImage.image = [blurImage blurredImageWithImage:self.photo.cashedThumbImage];
    
    [self loadBigImageFromURL:self.photo.bigImageURL];
    
    UIBarButtonItem *shareButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                      target:self
                                                      action:@selector(sharePhoto:)];
    
    UIBarButtonItem *favoritesButton =
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"favorites-icon"]
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(addToFavorites:)];
    
    UIButton *buttonInfo = [UIButton buttonWithType:UIButtonTypeInfoLight];
    UIBarButtonItem *aboutButton = [[UIBarButtonItem alloc] initWithCustomView:buttonInfo];
    [buttonInfo addTarget:self action:@selector(actionAbout:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = @[aboutButton, favoritesButton, shareButton];
    
    [self getInfoForPhoto:self.photo.photoID];
    [self getExifForPhoto:self.photo.photoID];
}


#pragma mark - Methods


- (void)loadBigImageFromURL:(NSString *)urlString
{
    [self.loadingView showLoadingViewOnView:self.view];
    self.tempImageView = [[UIImageView alloc] init];
    [self.tempImageView setImageWithURL:[NSURL URLWithString:urlString]];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showDownloadedImage) userInfo:nil repeats:NO];
    

}


- (void)showDownloadedImage
{
    self.fullScreenImage.image = self.tempImageView.image;
    [self.loadingView hideLoadingView];
}

- (void)getInfoForPhoto:(NSString *)photoID
{
    [self.flickrAPI loadInfoForPhotoID:photoID withCompletionBlock:^(NSDictionary *result, NSError *error) {
        
        [self generateAuthorInfoFromDictionary:result];
        
    }];
}

- (void)generateAuthorInfoFromDictionary:(NSDictionary *)dictionary
{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    NSDictionary *photo = dictionary[@"photo"];
    NSDictionary *owner = photo[@"owner"];
    
    if (owner[@"realname"] != nil) {
        [tempDict setValue:owner[@"realname"] forKey:@"author_name"];
    } else {
        [tempDict setValue:owner[@"username"] forKey:@"author_name"];
    }
    
    
    NSString *iconfarm = owner[@"iconfarm"];
    NSString *iconserver = owner[@"iconserver"];
    NSString *nsid = owner[@"nsid"];
    NSString *buddyiconUrl = nil;
    
    if ([iconfarm integerValue]) {
        buddyiconUrl = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/buddyicons/%@.jpg", iconfarm, iconserver, nsid];
        
    } else {
        buddyiconUrl = @"https://www.flickr.com/images/buddyicon.gif";
    }
    
    [tempDict setValue:buddyiconUrl forKey:@"buddyicon_url"];
    self.photo.author = tempDict;
    
}

- (void)getExifForPhoto:(NSString *)photoID
{
    [self.flickrAPI loadExifForPhotoID:photoID withCompletionBlock:^(NSDictionary *result, NSError *error) {
        
        NSLog(@"%@", result);
        [self generateExifFromDictionary:result];
        
    }];
}

- (void)generateExifFromDictionary:(NSDictionary *)dictionary
{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    NSDictionary *photo = dictionary[@"photo"];
    NSString *camera = photo[kCameraModel];
    if (camera) {
        [tempDict setValue:camera forKey:kCameraModel];
    } else {
        [tempDict setValue:@"no camera" forKey:kCameraModel];
    }
    
    NSArray *exif = photo[@"exif"];
    NSArray *exifTagName = @[kExposureTime, kAperture, kISO, kFlash, kFocalLength, kLensModel];

    for (NSDictionary *obj in exif) {
        for (NSString *tagName in exifTagName) {
            
            NSString *name = obj[@"tag"];
            
            if (name) {
                if ([tagName isEqualToString:name]) {
                    NSDictionary *dict = obj[@"raw"];
                    NSString *string = dict[@"_content"];
                    [tempDict setValue:string forKey:tagName];
                }
            }
            
            
        }
    }
    self.photo.exif = tempDict;
}


#pragma mark - Actions

- (void)addToFavorites:(UIButton *)sender
{
    NSLog(@"addToFavorites");
}

- (void)actionAbout:(UIButton *)sender
{
    AboutPhotoVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutPhotoVC"];
    vc.photo = self.photo;
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
    
    NSLog(@"actionAbout");
}

- (void)sharePhoto:(UIBarButtonItem *)sender {
    NSLog(@"sharePhoto");
}


@end

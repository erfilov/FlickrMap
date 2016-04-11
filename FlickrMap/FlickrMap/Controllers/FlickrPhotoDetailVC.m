#import "FlickrPhotoDetailVC.h"
#import "UIImage+Blur.h"
#import "LoadingView.h"
#import "FlickrPhoto.h"
#import "UIImageView+AFNetworking.h"
#import "FlickrAPI.h"
#import "AboutPhotoVC.h"


static NSString *const kExposureTime = @"ExposureTime";
static NSString *const kAperture = @"FNumber";
static NSString *const kISO = @"ISO";
static NSString *const kFlash = @"Flash";
static NSString *const kFocalLength = @"FocalLength";
static NSString *const kLensModel = @"LensModel";
static NSString *const kCameraModel = @"camera";


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

    
    UIButton *buttonInfo = [UIButton buttonWithType:UIButtonTypeInfoLight];
    UIBarButtonItem *aboutButton = [[UIBarButtonItem alloc] initWithCustomView:buttonInfo];
    [buttonInfo addTarget:self action:@selector(actionAbout:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = @[aboutButton, shareButton];
    
    [self getInfoForPhoto:self.photo.photoID];
    [self getExifForPhoto:self.photo.photoID];
}


#pragma mark - Methods


- (void)loadBigImageFromURL:(NSString *)urlString
{
    [self.loadingView showLoadingViewOnView:self.view];
    
    self.tempImageView = [[UIImageView alloc] init];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    __weak typeof(self) weakSelf = self;
    
    [self.tempImageView setImageWithURLRequest:request
        placeholderImage:nil
        success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            
            weakSelf.fullScreenImage.image = image;
            [weakSelf.loadingView hideLoadingView];
        
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            NSLog(@"error %@", [error localizedDescription]);
        }];
   

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


- (void)actionAbout:(UIButton *)sender
{
    AboutPhotoVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutPhotoVC"];
    vc.photo = self.photo;
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
}

- (void)sharePhoto:(UIBarButtonItem *)sender {
    NSLog(@"sharePhoto");
}


@end

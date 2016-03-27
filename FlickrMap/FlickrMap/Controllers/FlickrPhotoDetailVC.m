#import "FlickrPhotoDetailVC.h"
#import "UIImage+Blur.h"
#import "LoadingView.h"
#import "SessionManager.h"
#import "FlickrPhoto.h"
#import "UIImageView+AFNetworking.h"
#import "FlickrAPI.h"
#import "AboutPhotoVC.h"

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
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"favorites_icon"]
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(addToFavorites:)];
    
    UIButton *buttonInfo = [UIButton buttonWithType:UIButtonTypeInfoLight];
    UIBarButtonItem *aboutButton = [[UIBarButtonItem alloc] initWithCustomView:buttonInfo];
    [buttonInfo addTarget:self action:@selector(actionAbout:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = @[aboutButton, favoritesButton, shareButton];
    
    [self getInfoForPhoto:self.photoID];
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
        
        NSLog(@"%@", result);
        
        
    }];
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

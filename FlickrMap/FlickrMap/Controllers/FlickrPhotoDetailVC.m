#import "FlickrPhotoDetailVC.h"
#import "UIImage+Blur.h"
#import "LoadingView.h"
#import "SessionManager.h"
#import "FlickrPhoto.h"
#import "UIImageView+AFNetworking.h"

@interface FlickrPhotoDetailVC ()
@property (strong, nonatomic) IBOutlet UIImageView *fullScreenImage;
@property (strong, nonatomic) LoadingView *loadingView;
@property (strong, nonatomic) UIImageView *tempImageView;

@end




@implementation FlickrPhotoDetailVC


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.loadingView = [[LoadingView alloc] init];
    UIImage *blurImage = [[UIImage alloc] init];
    self.fullScreenImage.image = [blurImage blurredImageWithImage:self.image];
    
    [self loadBigImageFromURL:self.photo.bigImageURL];
    
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

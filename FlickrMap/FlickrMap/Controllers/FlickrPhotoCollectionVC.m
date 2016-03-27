#import "FlickrPhotoCollectionVC.h"
#import "FlickrPhotoCollectionViewCell.h"
#import "FlickrPhoto.h"
#import <UIImageView+AFNetworking.h>
#import "SessionManager.h"
#import "FlickrPhotoDetailVC.h"
#import "LoadingView.h"

typedef void(^CompletionBlockWithImage)(UIImage *image, NSError *error);

@interface FlickrPhotoCollectionVC () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSMutableDictionary<NSString *, UIImage *> *images;
//@property (strong, nonatomic) UIView *loadingView;
//@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) FlickrPhotoDetailVC *photoDetailVC;
@property (strong, nonatomic) LoadingView *loadingView;
@end





@implementation FlickrPhotoCollectionVC

static NSString * const reuseIdentifier = @"FlickrPhotoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadingView = [[LoadingView alloc] init];
    self.images = [[NSMutableDictionary alloc] init];
    self.photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FlickrPhotoDetailVC"];
    self.title = [NSString stringWithFormat:@"#%@", self.titleNavController];

    
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FlickrPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    FlickrPhoto *photo = self.photos[indexPath.row];
    cell.photo = photo;
    [cell setImageUrl:[NSURL URLWithString:photo.thumbImageUrl]];


    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectItemAtIndexPath");

    
    

}


#pragma mark - Methods



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSLog(@"prepareForSegue");
    
        self.photoDetailVC = segue.destinationViewController;
        FlickrPhotoCollectionViewCell *cell = sender;
        self.photoDetailVC.image = cell.imageView.image;
        self.photoDetailVC.photo = cell.photo;
        self.photoDetailVC.sessionManager = self.sessionManager;
        
    }
}




@end

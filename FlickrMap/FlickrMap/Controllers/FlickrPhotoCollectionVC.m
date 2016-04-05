#import "FlickrPhotoCollectionVC.h"
#import "FlickrPhotoCollectionViewCell.h"
#import "FlickrPhoto.h"
#import <UIImageView+AFNetworking.h>
#import "SessionManager.h"
#import "FlickrPhotoDetailVC.h"
#import "LoadingView.h"


@interface FlickrPhotoCollectionVC () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSDictionary<NSString *, FlickrPhoto *> *flickrPhotos;
@property (strong, nonatomic) FlickrPhotoDetailVC *photoDetailVC;
@property (strong, nonatomic) LoadingView *loadingView;
@property (strong, nonatomic) FlickrPhoto *currentPhoto;
@end

@implementation FlickrPhotoCollectionVC

static NSString * const reuseIdentifier = @"FlickrPhotoCell";

#pragma mark - Object lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadingView = [[LoadingView alloc] init];
    self.flickrPhotos = [[NSDictionary alloc] init];
    self.photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FlickrPhotoDetailVC"];
    self.title = [NSString stringWithFormat:@"#%@", self.titleNavController];

    self.flickrPhotos = [self fillDictionaryFromArray:self.photos];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FlickrPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    self.currentPhoto = self.photos[indexPath.row];
    cell.photo = self.currentPhoto;
    
    [cell setImageUrl:[NSURL URLWithString:self.currentPhoto.thumbImageUrl]];

    self.photoDetailVC.cellIndex = indexPath.row;


    return cell;
}
 

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        self.photoDetailVC = segue.destinationViewController;
        FlickrPhotoCollectionViewCell *cell = sender;
        cell.photo.cashedThumbImage = cell.imageView.image;
        self.photoDetailVC.image = cell.imageView.image;
        self.photoDetailVC.photo = cell.photo;
        self.photoDetailVC.photos = self.flickrPhotos;

        
    }
}

#pragma mark - Methods

- (NSDictionary *)fillDictionaryFromArray:(NSArray *)objects
{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithCapacity:[objects count]];
    [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempDict setObject:obj forKey:[NSString stringWithFormat:@"%d", (NSInteger)idx]];
    }];
    return tempDict;
}



@end

#import "FlickrPhotoCollectionVC.h"
#import "FlickrPhotoCollectionViewCell.h"
#import "FlickrPhoto.h"
#import <UIImageView+AFNetworking.h>
#import "SessionManager.h"
#import "FlickrPhotoDetailVC.h"
#import "LoadingView.h"
#import "FlickrPhotoFooterView.h"
#import "FlickrAPI.h"


@interface FlickrPhotoCollectionVC () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) FlickrPhotoDetailVC *photoDetailVC;
@property (strong, nonatomic) LoadingView *loadingView;
@property (strong, nonatomic) FlickrPhoto *currentPhoto;
@property (nonatomic) NSInteger pageNumber;
@end

@implementation FlickrPhotoCollectionVC

static NSString * const reuseIdentifier = @"FlickrPhotoCollectionViewCell";

#pragma mark - Object lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNumber = 1;
    self.flickrAPI = [[FlickrAPI alloc] init];
    self.loadingView = [[LoadingView alloc] init];
    self.photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FlickrPhotoDetailVC"];
    self.title = [NSString stringWithFormat:@"#%@", self.titleNavController];

    
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionFooter) {
        FlickrPhotoFooterView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FlickrPhotoFooterView" forIndexPath:indexPath];
        
        [footerview.nextButton addTarget:self action:@selector(loadNextPhotos) forControlEvents:UIControlEventTouchUpInside];
        
        reusableview = footerview;
    }
    
    return reusableview;
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

        
    }
}

#pragma mark - Methods

- (void)loadNextPhotos
{
    [self.loadingView showLoadingViewOnView:self.view];
    self.pageNumber++;
    
    NSString *requestString = [self convertToCorrectFormatText:self.titleNavController];
    
    [self.flickrAPI requestWithText:requestString page:self.pageNumber withCompletionBlock:^(NSDictionary *result, NSError *error) {
        NSArray *temp = [[NSArray alloc] init];
        temp = [self.flickrAPI generateArrayUrlFromResponseObject:result];
        
        NSMutableArray *indexes = [NSMutableArray array];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.photos];
        for (int i = 0; i < [temp count]; i++) {
            [indexes addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }
        
        [self.collectionView performBatchUpdates:^{
            [arr addObjectsFromArray:temp];
            self.photos = arr;
            [self.collectionView insertItemsAtIndexPaths:indexes];
        } completion:^(BOOL finished) {
            [self.loadingView hideLoadingView];
        }];
    }];
    
    
}

- (NSString *)convertToCorrectFormatText:(NSString *)text
{
    NSArray *temp = [[NSArray alloc] init];
    temp = [text componentsSeparatedByString:@" "];
    NSMutableString *result = [[NSMutableString alloc] init];
    
    [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result appendString:obj];
        if (!(idx == [temp count] - 1)) {
            [result appendString:@"%20"];
        }
        
    }];
    return result;
}


@end

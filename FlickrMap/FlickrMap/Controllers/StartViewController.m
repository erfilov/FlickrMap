#import "StartViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "LocationManager.h"
#import "FlickrPhoto.h"
#import <CoreLocation/CoreLocation.h>
#import "FlickrPhotoCollectionVC.h"
#import "SessionManager.h"
#import "FlickrAPI.h"
#import "LoadingView.h"
#import "UIImage+Blur.h"




@interface StartViewController () <UITextFieldDelegate>
@property (strong, nonatomic) SessionManager *sessionManager;
@property (strong, nonatomic) FlickrAPI *flickrAPI;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (copy, nonatomic) NSString *searchText;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) LoadingView *loadingView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIView *bgViewButton;

- (IBAction)actionSearch:(UIButton *)sender;
@end

@implementation StartViewController


#pragma mark - Object lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.flickrAPI = [[FlickrAPI alloc] init];
    self.loadingView = [[LoadingView alloc] init];
    self.bgViewButton.layer.cornerRadius = 5.f;
    
    [[LocationManager sharedInstance]
     startUpdatingLocationWithCompletionBlock:^(CLLocation *location, NSError *error) {
         
         NSLog(@"location - %@", location);
         
     }];
    
    [self configureNavTitle];


}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.searchTextField) {
        [self.searchTextField resignFirstResponder];
        self.searchText = self.searchTextField.text;
        NSString *requestString = [self convertToCorrectFormatText:self.searchTextField.text];
        [self getImagesForText:requestString];
    }
    return NO;
    
}

#pragma mark - Methods

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

- (void)getImagesForText:(NSString *)string
{
    [self.loadingView showLoadingViewOnView:self.view];
    
    FlickrPhotoCollectionVC *photoCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FlickrPhotoCollectionVC"];
    
    [self.flickrAPI requestWithText:string page:1 withCompletionBlock:^(NSDictionary *result, NSError *error) {
        
        photoCollectionVC.photos = [self.flickrAPI generateArrayUrlFromResponseObject:result];

        //CR :
        // again some strange logic with this session manager:
        // at this moment self.sessionManager is nil
        // also it's a singleton
        // and then, you initialize FlickrAPI class inside photoCollectionVC object
        // which also has a reference to session manager.
        photoCollectionVC.sessionManager = self.sessionManager;
        photoCollectionVC.titleNavController = self.searchText;
        [self.loadingView hideLoadingView];
        [self.navigationController pushViewController:photoCollectionVC animated:YES];
        
    }];
}

- (void)configureNavTitle
{
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flickrmap-logo"]];
    self.navigationItem.titleView = logo;
}



#pragma mark - Actions

- (IBAction)actionSearch:(UIButton *)sender {
    

    self.searchText = self.searchTextField.text;
    
    NSString *requestString = [self convertToCorrectFormatText:self.searchTextField.text];
    [self getImagesForText:requestString];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.searchTextField];
    if (!CGRectContainsPoint(self.searchTextField.frame, touchPoint)) {
        [self.searchTextField resignFirstResponder];
    }
}

@end

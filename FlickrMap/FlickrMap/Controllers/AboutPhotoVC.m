#import "AboutPhotoVC.h"
#import <MapKit/MapKit.h>
#import "FlickrPhoto.h"
#import "UIImageView+AFNetworking.h"

//CR :
// instead of #define better use something like
// static NSString *const kExposureTime = @"ExposureTime";

#define kExposureTime       @"ExposureTime"
#define kAperture           @"FNumber"
#define kISO                @"ISO"
#define kFlash              @"Flash"
#define kFocalLength        @"FocalLength"
#define kLensModel          @"LensModel"
#define kCameraModel        @"camera"

@interface AboutPhotoVC () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) FlickrPhoto *mapAnnotation;
@property (strong, nonatomic) IBOutlet UILabel *authorName;
@property (strong, nonatomic) IBOutlet UIImageView *buddyicon;
@property (strong, nonatomic) IBOutlet UILabel *cameraModel;
@property (strong, nonatomic) IBOutlet UILabel *cameraSubtitle;
@property (strong, nonatomic) IBOutlet UILabel *apertureLabel;
@property (strong, nonatomic) IBOutlet UILabel *exposureLabel;
@property (strong, nonatomic) IBOutlet UILabel *isoLabel;
@property (strong, nonatomic) IBOutlet UILabel *flashLabel;
@property (strong, nonatomic) IBOutlet UILabel *focalLengthLabel;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UIView *containerView;


@end

@implementation AboutPhotoVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureBuddyicon];
    NSString *iconURL = [self.photo.author valueForKey:@"buddyicon_url"];
    
    [self.buddyicon setImageWithURL:[NSURL URLWithString:iconURL]
                   placeholderImage:[UIImage imageNamed:@"placeholder-image"]];
    
        
    self.authorName.text = [self.photo.author valueForKey:@"author_name"];
    
    self.containerView.layer.cornerRadius = 5.f;
    
    

    [self showExifInfo];
    
    [self addAnnotation];
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.mapAnnotation.coordinate, 15000, 15000)];
    
}

- (void)showExifInfo
{
    self.exposureLabel.text = [self.photo.exif valueForKey:kExposureTime] ? : @"n/a";
    self.apertureLabel.text = [self.photo.exif valueForKey:kAperture] ? [NSString stringWithFormat:@"ƒ/%@", [self.photo.exif valueForKey:kAperture]] : @"n/a";
    self.isoLabel.text = [self.photo.exif valueForKey:kISO] ? : @"n/a";
    self.flashLabel.text = [self.photo.exif valueForKey:kFlash] ? : @"n/a";
    self.focalLengthLabel.text = [self.photo.exif valueForKey:kFocalLength] ? : @"n/a";
    self.cameraSubtitle.text = [self.photo.exif valueForKey:kLensModel] ? : @"n/a";
    self.cameraModel.text = [self.photo.exif valueForKey:kCameraModel] ? : @"n/a";

}

- (void)configureBuddyicon
{
    self.buddyicon.layer.cornerRadius = CGRectGetWidth(self.buddyicon.frame) / 2;
    self.buddyicon.layer.masksToBounds = NO;
    self.buddyicon.clipsToBounds = YES;
}

- (void)addAnnotation
{
    self.mapAnnotation = [[FlickrPhoto alloc] init];
    self.mapAnnotation.coordinate = self.photo.coordinate;
    self.mapAnnotation.title = self.photo.title;
    
    [self.mapView addAnnotation:self.mapAnnotation];


}



#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *identifier = @"Annotation";
    
    MKPinAnnotationView *pinAnnotation = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!pinAnnotation) {
        pinAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier: nil];
        pinAnnotation.canShowCallout = YES;
        pinAnnotation.enabled = YES;
    }
    
    pinAnnotation.annotation = annotation;
    
    return pinAnnotation;

}

#pragma mark - Actions

- (IBAction)actionClose:(UIBarButtonItem *)sender
{
    //CR :
    //viewController should not dismiss itself.
    // check this (with the question above): http://stackoverflow.com/a/24689553
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

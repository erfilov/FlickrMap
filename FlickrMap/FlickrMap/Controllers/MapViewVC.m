#import "MapViewVC.h"
#import <MapKit/MapKit.h>
#import "LocationManager.h"
#import "StartViewController.h"
#import "FlickrPhoto.h"
#import "FlickrPhotoMapAnnotation.h"
#import "UIImageView+AFNetworking.h"
#import "FlickrAPI.h"
#import "FlickrPhotoDetailVC.h"

@interface MapViewVC () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) LocationManager *locationManager;
@property (strong, nonatomic) StartViewController *vc;
@property (strong, nonatomic) FlickrAPI *flickrAPI;
@property (strong, nonatomic) SessionManager *sessionManager;
@property (strong, nonatomic) NSMutableDictionary *dict;
@property (copy, nonatomic) NSArray<FlickrPhotoMapAnnotation *> *mapAnnotations;
@property (strong, nonatomic) FlickrPhotoDetailVC *photoDetailVC;
@end




@implementation MapViewVC

#pragma mark - Object lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FlickrPhotoDetailVC"];
    self.vc = [[StartViewController alloc] init];
    [self.mapView setShowsUserLocation:YES];
    self.flickrAPI = [[FlickrAPI alloc] init];
    self.mapAnnotations = [[NSArray alloc] init];
    



}



#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSString *originalPhotoURL = nil;
    if ([view.annotation isKindOfClass:[FlickrPhotoMapAnnotation class]]) {
        originalPhotoURL = [(FlickrPhotoMapAnnotation*)view.annotation bigImageURL];
    }
    
    if (originalPhotoURL) {
        
        FlickrPhotoMapAnnotation *mapAnnotation = (FlickrPhotoMapAnnotation *)view.annotation;
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setImageWithURL:[NSURL URLWithString:originalPhotoURL] placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
        
        mapAnnotation.photo.cashedBigImage = mapAnnotation.cashedBigImage = imageView.image;
        [self performSegueWithIdentifier:@"showPhotoDetailFromMap" sender:mapAnnotation];
        
        //self.selectedFlickrPhoto = mapAnnotation;
        

        
    }
}

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
        
        pinAnnotation.leftCalloutAccessoryView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIButton *entryButton = (UIButton *)pinAnnotation.leftCalloutAccessoryView;
        [entryButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    pinAnnotation.annotation = annotation;
    
    return pinAnnotation;
}

- (void)mapView:(MKMapView *)mapView
    didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}




- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    NSLog(@"mapViewWillStartLocatingUser");
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}



- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self updateFlickrImagesInMap];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.leftCalloutAccessoryView isKindOfClass:[UIButton class]]) {
        if ([view.annotation isKindOfClass:[FlickrPhotoMapAnnotation class]]) {
            FlickrPhotoMapAnnotation *mapAnnotation = (FlickrPhotoMapAnnotation *)view.annotation;
            UIImage *image = mapAnnotation.cashedThumbImage;
            UIButton *entryButton = (UIButton *)view.leftCalloutAccessoryView;
            [entryButton setImage:image forState:UIControlStateNormal];
            [entryButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        }
    }
}






#pragma mark - Actions

- (void)actionInfo:(UIButton *)sender
{
    NSLog(@"actionInfo");
}



#pragma mark - Methods

- (void)generateMapAnnotationsForEntries:(NSDictionary *)entries
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    NSDictionary *dict = entries[@"photos"];
    NSArray *photos = dict[@"photo"];
    for (id obj in photos) {
        FlickrPhotoMapAnnotation *mapAnnotation = [[FlickrPhotoMapAnnotation alloc] initValuesFromDictionary:obj];
        
        if (mapAnnotation) {
             [annotations addObject:mapAnnotation];
        }
       
    }
    
    [self.mapView addAnnotations:annotations];
    [self.mapView setNeedsDisplay];
}

- (void)updateFlickrImagesInMap {
    
    for (id<MKAnnotation> obj in self.mapView.annotations) {
        if ([obj isKindOfClass:[FlickrPhotoMapAnnotation class]]) {
            [self.mapView removeAnnotation:obj];
        }
    }
    
    [self.flickrAPI loadImagesFromLocationBL:[self getBottomLeftCornerOfMap]
                                toLocationTR:[self getTopRightCornerOfMap]
                         withCompletionBlock:^(id result, NSError *error) {
                             
                             if ([result isKindOfClass:[NSDictionary class]] && result != nil) {
                                 
                                 [self generateMapAnnotationsForEntries:result];
                             } else {
                                 self.mapAnnotations = @[];
                             }
                             
                         }];
}




- (CLLocationCoordinate2D) getBottomLeftCornerOfMap {
    return [self.mapView convertPoint:CGPointMake(0, self.mapView.frame.size.height) toCoordinateFromView:self.mapView];
}

- (CLLocationCoordinate2D) getTopRightCornerOfMap {
    return [self.mapView convertPoint:CGPointMake(self.mapView.frame.size.width, 0) toCoordinateFromView:self.mapView];
}

#pragma mark - Navigations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPhotoDetailFromMap"]) {
        self.photoDetailVC = segue.destinationViewController;
        FlickrPhotoMapAnnotation *mapAnnotation = sender;
        self.photoDetailVC.photo = mapAnnotation.photo;
    }
}



@end

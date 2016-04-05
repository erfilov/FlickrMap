#import "MapViewVC.h"
#import <MapKit/MapKit.h>
#import "LocationManager.h"
#import "FlickrPhoto.h"
#import "UIImageView+AFNetworking.h"
#import "FlickrAPI.h"
#import "FlickrPhotoDetailVC.h"
#import "SessionManager.h"

static BOOL firstLocationHasBeenRetrieved = NO;

@interface MapViewVC () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) CLLocationCoordinate2D userLocation;
@property (strong, nonatomic) FlickrAPI *flickrAPI;
@property (strong, nonatomic) SessionManager *sessionManager;
@property (strong, nonatomic) NSMutableDictionary *dict;
@property (copy, nonatomic) NSArray<FlickrPhoto *> *mapAnnotations;
@property (strong, nonatomic) FlickrPhotoDetailVC *photoDetailVC;
@end




@implementation MapViewVC

#pragma mark - Object lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FlickrPhotoDetailVC"];
    [self.mapView setShowsUserLocation:YES];
    self.flickrAPI = [[FlickrAPI alloc] init];
    self.mapAnnotations = [[NSArray alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;



}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!firstLocationHasBeenRetrieved) {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            [self.locationManager requestWhenInUseAuthorization];
        self.mapView.showsUserLocation = NO;
    }
}


#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSString *originalPhotoURL = nil;
    if ([view.annotation isKindOfClass:[FlickrPhoto class]]) {
        originalPhotoURL = [(FlickrPhoto*)view.annotation bigImageURL];
    }
    
    if (originalPhotoURL) {
        
        FlickrPhoto *mapAnnotation = (FlickrPhoto *)view.annotation;
        UIImageView *imageView = [[UIImageView alloc] init];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:originalPhotoURL]];
        
        [imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            
            mapAnnotation.cashedBigImage = image;
        
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            NSLog(@"error %@", [error localizedDescription]);
        }];
        
        
        [self performSegueWithIdentifier:@"showPhotoDetailFromMap" sender:mapAnnotation];
        
        

        
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
    
    self.userLocation = userLocation.coordinate;
    [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
    if (!firstLocationHasBeenRetrieved) {
        firstLocationHasBeenRetrieved = YES;
        self.mapView.showsUserLocation = NO;
        self.mapView.userTrackingMode = MKUserTrackingModeNone;
        
        [self updateFlickrImagesInMap];
    }
    
    
    
    
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
        if ([view.annotation isKindOfClass:[FlickrPhoto class]]) {
            FlickrPhoto *mapAnnotation = (FlickrPhoto *)view.annotation;
            UIImage *image = mapAnnotation.cashedThumbImage;
            UIButton *entryButton = (UIButton *)view.leftCalloutAccessoryView;
            [entryButton setImage:image forState:UIControlStateNormal];
            [entryButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        }
    }
}

- (void) mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view.leftCalloutAccessoryView isKindOfClass:[UIButton class]]) {
        view.leftCalloutAccessoryView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIButton * entryButton = (UIButton *) view.leftCalloutAccessoryView;
        [entryButton setImage:nil forState:UIControlStateNormal];
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
        FlickrPhoto *mapAnnotation = [[FlickrPhoto alloc] initValuesFromDictionary:obj];
        
        if (mapAnnotation) {
             [annotations addObject:mapAnnotation];
        }
       
    }
    
    [self.mapView addAnnotations:annotations];
    [self.mapView setNeedsDisplay];
}

- (void)updateFlickrImagesInMap {
    
    for (id<MKAnnotation> obj in self.mapView.annotations) {
        if ([obj isKindOfClass:[FlickrPhoto class]]) {
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




- (CLLocationCoordinate2D)getBottomLeftCornerOfMap
{
    return [self.mapView convertPoint:CGPointMake(0, self.mapView.frame.size.height) toCoordinateFromView:self.mapView];
}

- (CLLocationCoordinate2D)getTopRightCornerOfMap
{
    return [self.mapView convertPoint:CGPointMake(self.mapView.frame.size.width, 0) toCoordinateFromView:self.mapView];
}


- (void)showAlertWithMessage:(NSString *)message isError:(BOOL)error
{
    NSString *title = @"Warning";
    NSString *cancelButton = @"Ok";
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_8_4) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:cancelButton
                                                  otherButtonTitles:nil];
        [alertView show];
        
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButton
                                                               style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}



#pragma mark - Navigations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPhotoDetailFromMap"]) {
        self.photoDetailVC = segue.destinationViewController;
        FlickrPhoto *mapAnnotation = sender;
        self.photoDetailVC.photo = mapAnnotation;
    }
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    //[self closeLoadingAlert];
    if (status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
        self.mapView.showsUserLocation = YES;
    } else if (status == kCLAuthorizationStatusRestricted) {
        [self showAlertWithMessage:@"Unable to retrieve your location." isError:YES];
    } else if (status == kCLAuthorizationStatusDenied) {
        [self showAlertWithMessage:@"You must authorize access to your location." isError:YES];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (!locations || locations.count < 1) return;
    [self.locationManager stopUpdatingLocation];
    
    self.userLocation = [(CLLocation *) [locations lastObject] coordinate];
    [self.mapView setCenterCoordinate:self.userLocation animated:YES];
    if (!firstLocationHasBeenRetrieved) {
        firstLocationHasBeenRetrieved = YES;
        self.mapView.showsUserLocation = NO;
        self.mapView.userTrackingMode = MKUserTrackingModeNone;
        
        [self updateFlickrImagesInMap];
        
    }
    
}


@end

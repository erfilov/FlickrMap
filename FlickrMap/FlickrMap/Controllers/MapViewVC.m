#import "MapViewVC.h"
#import <MapKit/MapKit.h>
#import "LocationManager.h"
#import "StartViewController.h"
#import "FlickrPhoto.h"
#import "FlickrPhotoMapAnnotation.h"
#import "UIImageView+AFNetworking.h"
#import "SessionManager.h"
#import "FlickrAPI.h"

@interface MapViewVC () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) LocationManager *locationManager;
- (IBAction)sendRequest:(UIButton *)sender;
@property (strong, nonatomic) StartViewController *vc;
@property (strong, nonatomic) FlickrAPI *flickrAPI;
@property (strong, nonatomic) SessionManager *sessionManager;
@property (strong, nonatomic) NSMutableDictionary *dict;
@property (copy, nonatomic) NSArray<FlickrPhotoMapAnnotation *> *mapAnnotations;
@end


static NSString *const kFlickrAPIKey                    = @"99ebbf2885ed731a2dbed15ab554771a";
//static NSString *const secret = @"0727051505b5afb1";
static NSString *const kFlickrBaseRESTURL               = @"https://api.flickr.com/services/rest/?method=";
static NSString *const kFlickrPhotosSearchMethod  = @"flickr.photos.search";
static NSString *const kFlickrJSONFormat                = @"format=json";
static NSString *const kFlickrApiKeyParameter           = @"api_key";
static NSString *const kFlickrLatitudeParameter         = @"lat=";
static NSString *const kFlickrLongitudeParameter        = @"lon=";
static NSString *const kFlickrBoundingBoxParameter      = @"bbox";
static NSString *const kFlickrPhotosExtras              = @"extras=geo,url_t,url_o,url_m";
static NSString *const kFlickrPhotosRadiusParameter           = @"radius=";
static NSString *const kFlickrPhotosRadiusUnitParameter = @"radius_units=km";
static NSString *const kFlickrPerPageParameter          = @"per_page=";
static NSString *const kFlickrPhotosMaxPhotosToRetrieve = @"30";
static NSString *const kFlickrPhotosResponseParamPhotos = @"photos";
static NSString *const kFlickrPhotosResponseParamPhoto  = @"photo";
static NSString *const kFlickrPhotosFlickrNoJSONCallback = @"nojsoncallback=1";



@implementation MapViewVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.vc = [[StartViewController alloc] init];
    [self.mapView setShowsUserLocation:YES];
    self.sessionManager = [SessionManager sharedManager];
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
        
        [self.sessionManager loadImageFromURL:originalPhotoURL withCompletionBlock:^(UIImage *image, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (image != nil) {
                    FlickrPhotoMapAnnotation *mapAnnotation = (FlickrPhotoMapAnnotation *)view.annotation;
                    mapAnnotation.cashedBigImage = image;
                    self.selectedFlickrPhoto = mapAnnotation;
                    //[self performSegueWithIdentifier:@"Show detail" sender:nil];
                }
                
            });
        
        }];
        
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

- (void)updateFlickrImagesInMap {
    
    for (id<MKAnnotation> obj in self.mapView.annotations) {
        if ([obj isKindOfClass:[FlickrPhotoMapAnnotation class]]) {
            [self.mapView removeAnnotation:obj];
        }
    }

    [self.flickrAPI loadImagesFromLocationBL:[self getBottomLeftCornerOfMap]
                                toLocationTR:[self getTopRightCornerOfMap]
                         withCompletionBlock:^(id result, NSError *error) {
                             
                             if ([result isKindOfClass:[NSDictionary class]]) {
                                 
                                 [self generateMapAnnotationsForEntries:result];
                             }
                             
                         }];
}



#pragma mark - Actions

- (void)actionInfo:(UIButton *)sender
{
    NSLog(@"actionInfo");
}


- (IBAction)sendRequest:(UIButton *)sender {
    NSLog(@"sendRequest");
    
    
    
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
//    self.mapAnnotations = annotations;
}



//- (void)addAnnotationFromArray:(NSArray *)annotations
//{
//    [annotations enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.mapView addAnnotation:obj];
//    }];
//}


- (CLLocationCoordinate2D) getBottomLeftCornerOfMap {
    return [self.mapView convertPoint:CGPointMake(0, self.mapView.frame.size.height) toCoordinateFromView:self.mapView];
}

- (CLLocationCoordinate2D) getTopRightCornerOfMap {
    return [self.mapView convertPoint:CGPointMake(self.mapView.frame.size.width, 0) toCoordinateFromView:self.mapView];
}

@end

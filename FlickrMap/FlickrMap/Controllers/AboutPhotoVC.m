#import "AboutPhotoVC.h"
#import <MapKit/MapKit.h>
#import "FlickrPhoto.h"
#import "FlickrPhotoMapAnnotation.h"

@interface AboutPhotoVC () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) FlickrPhotoMapAnnotation *mapAnnotation;

@end

@implementation AboutPhotoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addAnnotation];
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.mapAnnotation.coordinate, 15000, 15000)];
    
}

- (void)addAnnotation
{
    self.mapAnnotation = [[FlickrPhotoMapAnnotation alloc] init];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

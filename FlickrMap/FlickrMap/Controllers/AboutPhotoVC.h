#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class FlickrPhoto;

@interface AboutPhotoVC : UIViewController
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) FlickrPhoto *photo;
//CR : why this method declaration is in public interface?
- (IBAction)actionClose:(UIBarButtonItem *)sender;
@end

#import <UIKit/UIKit.h>
@class FlickrPhoto;

@interface ImageTableVC : UITableViewController
@property (copy, nonatomic) NSArray<FlickrPhoto *> *images;
@property (copy, nonatomic) NSString *searchText;

@end

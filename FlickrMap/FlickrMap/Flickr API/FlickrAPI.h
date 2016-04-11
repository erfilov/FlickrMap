#import <Foundation/Foundation.h>
#import "LocationManager.h"


//CR :
// there are no single place in code where you've checked for error,
// so user could be alerted about problems, or result parsing could be stopped.
// also the common practice is to use two different blocks - for completion with result and for failure with error.
// so you would always be sure that you success/failure code would not be executed at inappropriate moments
typedef void(^CompletionBlock)(NSDictionary *result, NSError *error);

@interface FlickrAPI : NSObject

//CR :
// it's better to hide this property in .m file
// Also, purpose of SessionManager class is not very clear for me.
// In FlickrAPI all calls are like 'self.sessionManager.manager GET ...',
// so you could just use 'AFHTTPSessionManager' here

//@property (strong, nonatomic) SessionManager *sessionManager;

- (NSArray *)generateArrayUrlFromResponseObject:(NSDictionary *)responseObject;

- (void)loadImagesFromLocationBL:(CLLocationCoordinate2D)bottomLeft
                    toLocationTR:(CLLocationCoordinate2D)topRight
             withCompletionBlock:(CompletionBlock)completionBlock;

- (void)requestWithText:(NSString *)text
    page:(NSInteger)pageNumber
    withCompletionBlock:(CompletionBlock)completionBlock;

- (void)loadInfoForPhotoID:(NSString *)photoID
     withCompletionBlock:(CompletionBlock)completionBlock;

- (void)loadExifForPhotoID:(NSString *)photoID
     withCompletionBlock:(CompletionBlock)completionBlock;

@end

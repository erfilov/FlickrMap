#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>

typedef void(^CompletionBlock)(NSDictionary *result, NSError *error);
typedef void(^CompletionBlockWithImage)(UIImage *image, UIImage *placeholderImage, NSError *error);


@interface SessionManager : NSObject
@property (strong, nonatomic) AFHTTPSessionManager *manager;

+ (instancetype)sharedManager;

- (void)loadImageFromURL:(NSString *)urlString
        withCompletionBlock:(CompletionBlockWithImage)completionBlock;

@end

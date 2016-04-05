#import "SessionManager.h"
#import <AFNetworking/AFNetworking.h>


static NSString *const kBaseAPIURL = @"https://api.flickr.com/services/rest/?method=";

@interface SessionManager ()
@end

@implementation SessionManager

#pragma mark - Object lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *apiURL = [NSURL URLWithString:kBaseAPIURL];
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:apiURL];
        
    }
    return self;
}


+ (instancetype)sharedManager
{
    __strong static SessionManager *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [[self alloc] init];
    });
    return sessionManager;
}





#pragma mark - Inner requests

- (void)loadImageFromURL:(NSString *)urlString
     withCompletionBlock:(CompletionBlockWithImage)completionBlock
{
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFImageResponseSerializer serializer];
    
    for (NSURLSessionDataTask *dataTask in self.manager.dataTasks) {
        [dataTask cancel];
    }

    
    [self.manager GET:urlString
           parameters:nil
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  UIImage *placeholder = [UIImage imageNamed:@"placeholder-image"];
                  
                  if (responseObject != nil) {
                      completionBlock(responseObject, placeholder, nil);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  if (error) {
                      completionBlock(nil, nil, error);
                  }
              }];
    
    
}




@end

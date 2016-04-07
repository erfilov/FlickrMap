#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//CR : this loading view animation looks nice!
@interface LoadingView : NSObject
- (void)showLoadingViewOnView:(UIView *)view;
- (void)hideLoadingView;
@end

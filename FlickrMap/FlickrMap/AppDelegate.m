#import "AppDelegate.h"
#import "LocationManager.h"
#import "AppearanceCustomization.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AppearanceCustomization new] applyGeneralCustomizations];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    return YES;
}


@end

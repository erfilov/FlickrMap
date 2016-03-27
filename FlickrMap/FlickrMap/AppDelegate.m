#import "AppDelegate.h"
#import "LocationManager.h"
#import "AppearanceCustomization.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AppearanceCustomization new] applyGeneralCustomizations];
    return YES;
}


@end

#import "AppearanceCustomization.h"
#import <UIKit/UIKit.h>

@implementation AppearanceCustomization

+ (instancetype)new {
    return [[AppearanceCustomization alloc] init];
}

+ (UIColor *)blackColor {
    return [UIColor blackColor];
}


+ (UIColor *)whiteColor {
    return [UIColor whiteColor];
}


- (void)customizeNavigationBar {
    UINavigationBar *appearance = [UINavigationBar appearance];
    [appearance setBarTintColor:[AppearanceCustomization blackColor]];
    [appearance setTintColor:[AppearanceCustomization whiteColor]];

    appearance.titleTextAttributes = @{NSForegroundColorAttributeName : [AppearanceCustomization whiteColor]};
}

- (void)customizeTabBar {
    UITabBar *appearance = [UITabBar appearance];
    [appearance setBarTintColor:[AppearanceCustomization blackColor]];
    [appearance setTintColor:[AppearanceCustomization whiteColor]];
}

- (void)applyGeneralCustomizations {
    [self customizeNavigationBar];
    [self customizeTabBar];
}

@end

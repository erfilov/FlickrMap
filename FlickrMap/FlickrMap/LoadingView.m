#import "LoadingView.h"

@interface LoadingView ()
@property (strong, nonatomic) UIView *loadingView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@end

@implementation LoadingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.loadingView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return self;
}

- (void)showLoadingViewOnView:(UIView *)view
{
    self.loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    self.loadingView.clipsToBounds = YES;
    self.loadingView.hidden = NO;
    self.loadingView.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
    float circleRadius = 5;
    UIColor *blueColor = [UIColor colorWithRed:0.00 green:0.39 blue:0.86 alpha:1.0];
    UIColor *pinkColor = [UIColor colorWithRed:1.00 green:0.00 blue:0.52 alpha:1.0];
    
    UIView *circle1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.loadingView.bounds),
                                                               CGRectGetMinY(self.loadingView.bounds),
                                                               circleRadius * 2,
                                                               circleRadius * 2)];
    
    circle1.layer.cornerRadius = circle1.frame.size.width / 2;
    circle1.backgroundColor = blueColor;
    
    UIView *circle2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.loadingView.bounds),
                                                               CGRectGetMinY(self.loadingView.bounds),
                                                               circleRadius * 2,
                                                               circleRadius * 2)];
    
    circle2.layer.cornerRadius = circle2.frame.size.width / 2;
    circle2.backgroundColor = blueColor;

    UIView *circle3 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.loadingView.bounds),
                                                               CGRectGetMinY(self.loadingView.bounds),
                                                               circleRadius * 2,
                                                               circleRadius * 2)];
    
    circle3.layer.cornerRadius = circle2.frame.size.width / 2;
    circle3.backgroundColor = blueColor;

    circle1.center = CGPointMake(CGRectGetMidX(self.loadingView.bounds) - circleRadius * 4,
                                 CGRectGetMidY(self.loadingView.bounds));
    
    circle2.center = CGPointMake(CGRectGetMidX(self.loadingView.bounds), CGRectGetMidY(self.loadingView.bounds));
    circle3.center = CGPointMake(CGRectGetMidX(self.loadingView.bounds) + circleRadius * 4,
                                 CGRectGetMidY(self.loadingView.bounds));
    
    [self.loadingView addSubview:circle1];
    [self.loadingView addSubview:circle2];
    [self.loadingView addSubview:circle3];
    
    self.loadingView.alpha = 0;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.loadingView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.4
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut |
                                    UIViewAnimationOptionAutoreverse |
                                    UIViewAnimationOptionRepeat
         
                         animations:^{
                             circle1.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
                             circle1.backgroundColor = pinkColor;
                         } completion:nil];
        
        
        [UIView animateWithDuration:0.4
                              delay:0.25
                            options:UIViewAnimationOptionCurveEaseInOut |
                                    UIViewAnimationOptionAutoreverse |
                                    UIViewAnimationOptionRepeat
         
                         animations:^{
                             circle2.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
                             circle2.backgroundColor = pinkColor;
                         } completion:nil];
        
        
        [UIView animateWithDuration:0.4
                              delay:0.5
                            options:UIViewAnimationOptionCurveEaseInOut |
                                    UIViewAnimationOptionAutoreverse |
                                    UIViewAnimationOptionRepeat
         
                         animations:^{
                             circle3.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
                             circle3.backgroundColor = pinkColor;
                         } completion:nil];
    }];
    
    [view addSubview:self.loadingView];
}

- (void)hideLoadingView {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.loadingView.alpha = 0;
                     } completion:^(BOOL finished) {
                         self.loadingView.hidden = YES;
                         for (UIView *view in self.loadingView.subviews) {
                             [view removeFromSuperview];
                         }
                     }];
}


//- (void)showLoadingViewOnView:(UIView *)view
//{
//    self.loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
//    self.loadingView.clipsToBounds = YES;
//    self.loadingView.hidden = NO;
//    self.loadingView.layer.cornerRadius = 10.0;
//    self.loadingView.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
//    
//    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    self.activityIndicator.frame = CGRectMake(65, 10, self.activityIndicator.bounds.size.width, self.activityIndicator.bounds.size.height);
//    [self.loadingView addSubview:self.activityIndicator];
//    
//    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, 130, 22)];
//    loadingLabel.backgroundColor = [UIColor clearColor];
//    loadingLabel.textColor = [UIColor whiteColor];
//    loadingLabel.adjustsFontSizeToFitWidth = YES;
//    loadingLabel.textAlignment = UIBaselineAdjustmentAlignCenters;
//    loadingLabel.text = @"Loading...";
//    [self.loadingView addSubview:loadingLabel];
//    self.loadingView.alpha = 0;
//    self.loadingView.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
//    
//    [UIView animateWithDuration:0.3
//                          delay:0
//                        options:UIViewAnimationOptionCurveLinear
//                     animations:^{
//                         
//                         self.loadingView.alpha = 1;
//                         self.loadingView.transform = CGAffineTransformIdentity;
//                     }
//                     completion:^(BOOL finished) { }];
//    
//    [view addSubview:self.loadingView];
//    [self.activityIndicator startAnimating];
//}
//
//- (void)hideLoadingView {
//    [UIView animateWithDuration:0.3
//                          delay:0
//                        options:UIViewAnimationOptionCurveLinear
//                     animations:^{
//                         self.loadingView.transform = CGAffineTransformMakeScale(3.0f, 3.0f);
//                         self.loadingView.alpha = 0;
//                     }
//                     completion:^(BOOL finished) {
//                         self.loadingView.hidden = YES;
//                     }];
//    [self.activityIndicator stopAnimating];
//}

@end

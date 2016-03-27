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
        self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(75, 155, 170, 90)];
    }
    return self;
}

- (void)showLoadingViewOnView:(UIView *)view
{
    self.loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    self.loadingView.clipsToBounds = YES;
    self.loadingView.hidden = NO;
    self.loadingView.layer.cornerRadius = 10.0;
    self.loadingView.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.frame = CGRectMake(65, 10, self.activityIndicator.bounds.size.width, self.activityIndicator.bounds.size.height);
    [self.loadingView addSubview:self.activityIndicator];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, 130, 22)];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.adjustsFontSizeToFitWidth = YES;
    loadingLabel.textAlignment = UIBaselineAdjustmentAlignCenters;
    loadingLabel.text = @"Loading...";
    [self.loadingView addSubview:loadingLabel];
    self.loadingView.alpha = 0;
    self.loadingView.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.loadingView.alpha = 1;
                         self.loadingView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) { }];
    
    [view addSubview:self.loadingView];
    [self.activityIndicator startAnimating];
}

- (void)hideLoadingView {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.loadingView.transform = CGAffineTransformMakeScale(3.0f, 3.0f);
                         self.loadingView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.loadingView.hidden = YES;
                     }];
    [self.activityIndicator stopAnimating];
}

@end

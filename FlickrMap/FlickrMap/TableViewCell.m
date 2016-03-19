#import "TableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface TableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UILabel *labelImageTitle;


@end

@implementation TableViewCell

- (void)setImageUrl:(NSURL *)imageURL
{
    [self.imageV setImageWithURL:imageURL];
}

- (void)setImageTitle:(NSString *)imageTitle
{
    self.labelImageTitle.text = imageTitle;
}


@end

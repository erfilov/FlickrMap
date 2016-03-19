//
//  TableViewCell.h
//  FlickrMap
//
//  Created by Vik on 19.03.16.
//  Copyright © 2016 Viktor Erfilov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
- (void)setImageUrl:(NSURL *)imageURL;
- (void)setImageTitle:(NSString *)imageTitle;
@end

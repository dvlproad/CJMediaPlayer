//
//  VideoListCell.h
//  MTMediaPlayer
//
//  Created by 吴君恺 on 16/3/10.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoListCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIView *videoBackgroundView;
@property (nonatomic, strong, readonly) UIImageView *coverView;

@end

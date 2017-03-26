//
//  VideoListCell.m
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.

//

#import "PureLayout.h"

#import "VideoListCell.h"

@interface VideoListCell ()

@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UIView *videoBackgroundView;
@property (nonatomic, strong, readwrite) UIImageView *coverView;

@end

@implementation VideoListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _titleLabel = [[UILabel alloc] initForAutoLayout];
    _titleLabel.minimumScaleFactor = 0.3;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(8, 8, 8, 8) excludingEdge:ALEdgeBottom];
    [_titleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow + 10
                                   forAxis:UILayoutConstraintAxisVertical];
    
    UIView *playerAndCoverBox = [[UIView alloc] initForAutoLayout];
    [self.contentView addSubview:playerAndCoverBox];
    [playerAndCoverBox autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [playerAndCoverBox autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleLabel];
    
    _coverView = [[UIImageView alloc] initForAutoLayout];
    _coverView.backgroundColor = [UIColor greenColor];
    _coverView.clipsToBounds = YES;
    _coverView.contentMode = UIViewContentModeScaleAspectFit;
    [playerAndCoverBox addSubview:_coverView];
    [_coverView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    _videoBackgroundView = [[UIView alloc] initForAutoLayout];
    [playerAndCoverBox addSubview:_videoBackgroundView];
    [_videoBackgroundView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

- (void)prepareForReuse {
    for (UIView *subView in self.videoBackgroundView.subviews) {
        [subView removeFromSuperview];
    }
    _coverView.backgroundColor = [UIColor greenColor];
}

@end

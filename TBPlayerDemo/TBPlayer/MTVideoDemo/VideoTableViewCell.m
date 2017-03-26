//
//  VideoTableViewCell.m
//  TBPlayer
//
//  Created by dvlproad on 16/3/23.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "MTAVPlayerController.h"

@interface VideoTableViewCell ()



@end

@implementation VideoTableViewCell


- (void)awakeFromNib
{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.playerView = [[MTAVPlayerView alloc] initWithFrame:CGRectZero];
    self.playerView.backgroundColor = [UIColor redColor];
    
    __weak typeof(self) weakSelf = self;
    self.playerView.getVideoUrl = ^NSString *{
        return weakSelf.videoModel.videoUrl;
    };

    [self addSubview:self.playerView];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)reset
{
    self.videoModel = nil;
    if (self.playerView.playerStatus != MTAVPlayerStateUnStart) {
        [self.playerView stop];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.playerView.frame = self.bounds;
}



+ (CGFloat)cellHeight
{
    return 240.0f;
}


@end

//
//  VideoTableViewCell.h
//  TBPlayer
//
//  Created by dvlproad on 16/3/23.
//  Copyright © 2016年 SF. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VideoModel.h"
#import "MTAVPlayerView.h"

@class MTAVPlayerView;

@interface VideoTableViewCell : UITableViewCell

@property(nonatomic, weak)VideoModel *videoModel;
@property(nonatomic, strong)MTAVPlayerView *playerView;

+ (CGFloat)cellHeight;

- (void)reset;

@end

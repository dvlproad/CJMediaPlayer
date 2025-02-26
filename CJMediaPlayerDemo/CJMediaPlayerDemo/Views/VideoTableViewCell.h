//
//  VideoTableViewCell.h
//  TBPlayer
//
//  Created by dvlproad on 16/3/23.
//  Copyright © 2016年 SF. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VideoModel.h"
#import <CJPlayer/CJAVPlayerView.h>

@class CJAVPlayerView;

@interface VideoTableViewCell : UITableViewCell

@property(nonatomic, weak) VideoModel *videoModel;
@property(nonatomic, strong) CJAVPlayerView *playerView;

+ (CGFloat)cellHeight;

- (void)reset;

@end

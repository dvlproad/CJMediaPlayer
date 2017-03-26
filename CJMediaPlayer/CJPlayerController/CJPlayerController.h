//
//  CJPlayerController.h
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CJPlayerView.h"
#import "CJPlayerMaskView.h"


@interface CJPlayerController : NSObject

@property (nonatomic, strong) CJPlayerView *view;
@property (nonatomic, assign) BOOL fullscreen; // 当前视频播放器是否是全屏状态

#pragma mark - set url
/**
 *  当初始化时没有传入URL时，可以使用此接口传入
 *
 *  @param videoURL     视频的播放地址
 *  @param coverImage   视频的封面图（用于开始播放前展示）
 *  @param needCache    是否需要缓存（一般当视频长度不超过15s时不需要缓存）
 *  @param maskType     播放器的mask类型
 */
- (void)setVideoURL:(NSURL *)videoURL
         coverImage:(UIImage *)coverImage
          needCache:(BOOL)needCache
           maskType:(CJPlayerMaskViewType)maskType;

#pragma mark  接口

- (void)play;

- (void)pause;

- (void)seekToPercentDiscretely:(float)percent completion:(void (^)(BOOL finished))completion;

- (void)reset;

- (NSTimeInterval)duration;

@end

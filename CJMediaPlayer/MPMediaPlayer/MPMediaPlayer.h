//
//  MPMediaPlayer.h
//  MeituMV
//
//  Created by 张闽 on 15/4/25.
//  Copyright (c) 2015年 美图网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMediaDefine.h"
#import "MTVideoView.h"

@protocol MPMediaPlayerDelegate;

@interface MPMediaPlayer : NSObject

@property (strong, nonatomic) NSURL *url;
@property (nonatomic, assign) BOOL needCache;/** update by lichq */

@property (assign, nonatomic) MPMediaPlayerStatus status;

@property(weak, nonatomic) id <MPMediaPlayerDelegate> delegate;

@property(strong, readonly, nonatomic) MTVideoView *videoView;

+ (instancetype)shared;

- (void)setUrl:(NSURL *)url withCache:(BOOL)needCache;

- (void) replay;

- (void)play;

- (void)pause;

- (void)willStartSeek;

- (void)seekToPercent:(float)percent completion:(void (^)(BOOL finished))completion;

- (void)didEndSeek;

- (void)reset;

- (BOOL)isPlaying;

- (NSTimeInterval)duration;

- (BOOL)readyForPlay;

- (void)cancel;

@end

@protocol MPMediaPlayerDelegate <NSObject>

- (void)player:(MPMediaPlayer *)player statusDidChanged:(MPMediaPlayerStatus)status;

- (void)player:(MPMediaPlayer *)player timeDidChanged:(NSTimeInterval)time;

- (void)player:(MPMediaPlayer *)player loadFailed:(NSError *)error;

@end

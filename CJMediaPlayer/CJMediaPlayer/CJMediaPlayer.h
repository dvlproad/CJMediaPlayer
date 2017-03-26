//
//  CJMediaPlayer.h
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJMediaPlayerDefine.h"
#import "CJVideoView.h"

@protocol CJMediaPlayerDelegate;

@interface CJMediaPlayer : NSObject

@property (strong, nonatomic) NSURL *url;
@property (nonatomic, assign) BOOL needCache;/** update by lichq */

@property (assign, nonatomic) CJMediaPlayerStatus status;

@property(weak, nonatomic) id <CJMediaPlayerDelegate> delegate;

@property(strong, readonly, nonatomic) CJVideoView *videoView;

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

@protocol CJMediaPlayerDelegate <NSObject>

- (void)player:(CJMediaPlayer *)player statusDidChanged:(CJMediaPlayerStatus)status;

- (void)player:(CJMediaPlayer *)player timeDidChanged:(NSTimeInterval)time;

- (void)player:(CJMediaPlayer *)player loadFailed:(NSError *)error;

@end

//
//  MTAVPlayer.h
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/9.
//  Copyright © 2016年 dvlproad. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "CJAVPlayerView.h"



@interface CJAVPlayerController : NSObject

+ (instancetype)sharedInstance;

- (void)playWithMediaUrl:(NSURL *)url OnPlayerView:(CJAVPlayerView *)playerView;

- (void)resume;
- (void)pause;
- (void)slidePause;
- (void)stop;
- (void)seekToTime:(CGFloat)seconds;



@end

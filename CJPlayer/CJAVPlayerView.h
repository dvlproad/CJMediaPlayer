//
//  CJAVPlayerView.h
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/9.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


typedef NSString *(^GetVideoUrl)();


//播放器的状态
typedef NS_ENUM(NSInteger, MTAVPlayerState) {
    
    MTAVPlayerStateUnStart      = 0,       /** 未开始, 显示海报 */
    
    MTAVPlayerStateBuffering    = 1,       /** 缓冲 */
    MTAVPlayerStatePlaying      = 2,       /** 播放中 */

    MTAVPlayerStatePause        = 3,       /** 暂停 */
    MTAVPlayerStateSlidePause   = 4,       /** 滑动暂停 */

};




@interface CJAVPlayerView : UIView


@property(nonatomic, copy)GetVideoUrl getVideoUrl;

@property (nonatomic ,strong) AVPlayer *player;                         //播放器
@property (nonatomic, assign) MTAVPlayerState playerStatus;             //播放状态



//播放，暂停，停止（UI操作）

- (void)playOrPause;

- (void)stop;


/**
 *  设置滑块的滑动最大范围值
 *
 *  @param maxValue 最大范围值
 */
- (void)setPlaySliderMaxValue:(CGFloat)maxValue;


/**
 *  更新滑块的进度值
 *
 *  @param currentSecond 当前播放时间
 */
- (void)updateProgressSlider:(CGFloat)currentSecond;



/**
 *  更新当前播放时间
 *
 *  @param time 时间
 */
- (void)updateCurrentTime:(CGFloat)time;


/**
 *  更新总时间
 *
 *  @param time 时间
 */
- (void)updateTotalTime:(CGFloat)time;




@end

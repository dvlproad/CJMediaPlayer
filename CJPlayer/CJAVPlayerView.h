//
//  CJAVPlayerView.h
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/9.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


//播放器的状态
typedef NS_ENUM(NSInteger, CJAVPlayerState) {
    
    CJAVPlayerStateUnStart      = 0,       /** 未开始, 显示海报 */
    
    CJAVPlayerStateBuffering    = 1,       /** 缓冲 */
    CJAVPlayerStatePlaying      = 2,       /** 播放中 */

    CJAVPlayerStatePause        = 3,       /** 暂停 */
    CJAVPlayerStateSlidePause   = 4,       /** 滑动暂停 */

};




@interface CJAVPlayerView : UIView {
    
}

@property (nonatomic, copy) NSURL *(^getVideoPlayURL)();                 // 点击播放时候，要播放的视频地址的获取

@property (nonatomic ,strong) AVPlayer *player;                         //播放器
@property (nonatomic, assign) CJAVPlayerState playerStatus;             //播放状态



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

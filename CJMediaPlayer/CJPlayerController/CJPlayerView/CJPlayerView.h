//
//  CJPlayerView.h
//  MTMediaPlayer
//
//  Created by lichq on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTVideoView.h"
#import "CJPlayerMaskView.h"

@class CJPlayerView;

@protocol CJPlayerViewDelegate <NSObject>

/**
 *  slider值改变时候的事件
 *
 *  @param playerView The maskView requesting this information.
 *  @param slider   The slider which value change.
 */
- (void)mpPlayerView:(CJPlayerView *)playerView sliderValueChange:(CJPlayerSlider *)slider;

/**
 *  slider开始Touch
 *
 *  @param playerView The maskView requesting this information.
 *  @param slider   The slider which be touched.
 */
- (void)mpPlayerView:(CJPlayerView *)playerView sliderTouchBegan:(CJPlayerSlider *)slider;

/**
 *  slider结束Touch
 *
 *  @param playerView The maskView requesting this information.
 *  @param slider   The slider which be touched.
 */
- (void)mpPlayerView:(CJPlayerView *)playerView sliderTouchEnd:(CJPlayerSlider *)slider;

/**
 *  全屏按钮点击
 * 
 *  @param playerView The maskView requesting this information.
 *  @param button 按钮
 */

- (void)mpPlayerView:(CJPlayerView *)playerView fullScreenButtonClicked:(UIButton *)button;

/**
 *  CJPlayerMaskView Touch事件
 *
 *  @param playerView The maskView requesting this information.
 *  @param touches  A set of UITouch instances that represent the touches for the starting phase of the event represented by event.
 *  @param event    An object representing the event to which the touches belong.
 */
- (void)mpPlayerView:(CJPlayerView *)playerView touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

@end


@interface CJPlayerView : UIView

@property (nonatomic, assign) id <CJPlayerViewDelegate> delegate;

- (instancetype)initWithPlayerView:(UIView *)_playerView;

/**
 *  根据类型重置UI
 *
 *  @param maskType 类型
 *  @param coverImage 背景图
 */
- (void)resetPlayerViewWithMaskViewType:(CJPlayerMaskViewType)maskType coverImage:(UIImage *)coverImage;

/**
 *  隐藏CoverImageView
 */
- (void)hiddenCoverImageView;

/**
 *  设置加载状态
 *
 *  @param loading 是否正加载
 */
- (void)setLoadingImageViewStatus:(BOOL)loading;

/**
 *  是否隐藏播放按钮图片
 *
 *  @param hidden 是否隐藏
 */
- (void)hiddenplayImageView:(BOOL)hidden;

/**
 *  是否全屏显示
 *
 *  @param fullScreen 是否全屏
 */
- (void)showWithFullScreen:(BOOL)fullScreen;

/**
 *  更新当前时间
 *
 *  @param time 当前时间
 */
- (void)updateCurrentTime:(NSInteger)time;

/**
 *  更新总时间
 *
 *  @param time 总时间
 */
- (void)updateTotalTime:(NSInteger)time;

/**
 *  更新滑动条
 *
 *  @param value 要滑动到的值
 */
- (void)updateSliderValue:(CGFloat)value;

/**
 *  当前BottomView的隐藏状态
 *
 *  @return 是否隐藏了
 */
- (BOOL)isHiddenBottomView;

/**
 *  隐藏BottomView
 *
 *  @param hidden 是否需要隐藏
 */
- (void)hiddenBottomView:(BOOL)hidden;

@end

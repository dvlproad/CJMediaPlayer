//
//  CJPlayerMaskView.h
//  MTMediaPlayer
//
//  Created by lichq on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CJPlayerProgressView.h"
#import "MPLoadingProgressView.h"


/**
 *  控制器类型(显示哪些按钮等)
 *
 */
typedef NS_ENUM(NSUInteger, CJPlayerMaskViewType){
    CJPlayerMaskViewTypeNormal = 0,             /**< 进度条及展开全屏按钮 */
    CJPlayerMaskViewTypeProgressOnly,           /**< 仅显示进度条 */
    CJPlayerMaskViewTypeFullScreenButtonOnly    /**< 仅显示展开全屏按钮 */
};


@class CJPlayerMaskView;

static const CGFloat s_kProgressViewHideTime = 5.0f;

@protocol CJPlayerMaskViewDelegate <NSObject>

/**
 *  全屏按钮点击
 *
 *  @param maskView The maskView requesting this information.
 *  @param button 按钮
 */
- (void)cjPlayerMaskView:(CJPlayerMaskView *)maskView fullScreenButtonClicked:(UIButton *)button;

/**
 *  slider值改变时候的事件
 *
 *  @param maskView The maskView requesting this information.
 *  @param slider   The slider which value change.
 */
- (void)cjPlayerMaskView:(CJPlayerMaskView *)maskView sliderValueChange:(CJPlayerSlider *)slider;

/**
 *  slider开始Touch
 *
 *  @param maskView The maskView requesting this information.
 *  @param slider   The slider which be touched.
 */
- (void)cjPlayerMaskView:(CJPlayerMaskView *)maskView sliderTouchBegan:(CJPlayerSlider *)slider;

/**
 *  slider结束Touch
 *
 *  @param maskView The maskView requesting this information.
 *  @param slider   The slider which be touched.
 */
- (void)cjPlayerMaskView:(CJPlayerMaskView *)maskView sliderTouchEnd:(CJPlayerSlider *)slider;

/**
 *  CJPlayerMaskView Touch事件
 *
 *  @param maskView The maskView requesting this information.
 *  @param touches  A set of UITouch instances that represent the touches for the starting phase of the event represented by event.
 *  @param event    An object representing the event to which the touches belong.
 */
- (void)cjPlayerMaskView:(CJPlayerMaskView *)maskView touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;


@end



@interface CJPlayerMaskView : UIView {
    
}
@property (nonatomic, assign) id <CJPlayerMaskViewDelegate> delegate;

@property (nonatomic, strong) UIImageView *playImageView; /**< 播放按钮，若没有设置则使用默认图片 */
@property (nonatomic, strong) MPLoadingProgressView *loadingView; /**< 加载视图 */
@property (nonatomic, strong) UIButton *fullScreenButton; /**< 全屏按钮，若没有设置则使用默认图片 */
@property (nonatomic, strong) CJPlayerProgressView *playerProgressView; /**< 底部进度控制 */

/**
 *  根据类型重置UI
 *
 *  @param maskType 类型
 */
- (void)resetMaskViewWithMaskViewType:(CJPlayerMaskViewType)maskType;


@end

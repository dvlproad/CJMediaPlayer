//
//  CJPlayerProgressView.h
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CJBaseUIKit/CJPlayerSlider.h>

@interface CJPlayerProgressView : UIView {
    
}
@property (nonatomic, weak) id <CJPlayerSliderDelegate> playerSliderDelegate;

/**
 *  重置所有值
 *
 */
- (void)resetValue;

/**
 *  更新开始时间
 *
 *  @param time 开始时间
 */
- (void)updateStartTime:(NSInteger)time;

/**
 *  更新总时长
 *
 *  @param time 总时长
 */
- (void)updateTotalTime:(NSInteger)time;

/**
 *  更新开始时间
 *
 *  @param value 开始时间
 */
- (void)updateSliderValue:(CGFloat)value;

@end

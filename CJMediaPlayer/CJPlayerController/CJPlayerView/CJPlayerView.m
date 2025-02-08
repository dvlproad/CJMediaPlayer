//
//  CJPlayerView.m
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJPlayerView.h"
#import <PureLayout/PureLayout.h>

@interface CJPlayerView () <CJPlayerMaskViewDelegate> {
    
}
@property (nonatomic, strong) CJPlayerMaskView *maskView;
@property (nonatomic, strong) UIImageView *coverImageView; /**< 用于产生更好的播放效果 不要直接黑屏闪过去 */

@end

@implementation CJPlayerView

- (instancetype)initWithPlayerView:(UIView *)playerView {
    self = [super init];
    if (self) {
        [self addSubview:playerView];
        playerView.translatesAutoresizingMaskIntoConstraints = NO;
        [playerView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [playerView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [playerView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [playerView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.clipsToBounds = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImageView.backgroundColor = [UIColor blackColor];
        [self addSubview:_coverImageView];
        _coverImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [_coverImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        CJPlayerMaskView *maskView = [[CJPlayerMaskView alloc] initWithFrame:CGRectZero];
        maskView.delegate = self;
        [self addSubview:maskView];
        maskView.translatesAutoresizingMaskIntoConstraints = NO;
        [maskView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [maskView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [maskView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [maskView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        self.maskView = maskView;
    }
    return self;
}

/** 完整的描述请参见文件头部 */
- (void)resetPlayerViewWithMaskViewType:(CJPlayerMaskViewType)maskType coverImage:(UIImage *)coverImage {
    self.coverImageView.image = coverImage;
    self.coverImageView.hidden = NO;
    self.coverImageView.alpha = 1;
    
    [self.maskView resetMaskViewWithMaskViewType:maskType];
}

/** 完整的描述请参见文件头部 */
- (void)hiddenCoverImageView {
    if (!self.coverImageView.hidden || self.coverImageView.alpha != 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.coverImageView.alpha = 0;
        } completion:^(BOOL finished) {
            // double check because we might call [reset] midway
            if (self.coverImageView.alpha == 0) {
                self.coverImageView.hidden = YES;
            }
        }];
    }
}

/** 完整的描述请参见文件头部 */
- (void)setLoadingImageViewStatus:(BOOL)loading {
    if (loading) {
        self.maskView.loadingView.hidden = NO;
        [self.maskView.loadingView startAnimating];
    }else {
        self.maskView.loadingView.hidden = YES;
        [self.maskView.loadingView stopAnimating];
    }
}

/** 完整的描述请参见文件头部 */
- (void)hiddenplayImageView:(BOOL)hidden {
    self.maskView.playImageView.hidden = hidden;
}

/** 完整的描述请参见文件头部 */
- (void)showWithFullScreen:(BOOL)fullScreen {
    [self.maskView.fullScreenButton setSelected:fullScreen];
}

/** 完整的描述请参见文件头部 */
- (void)updateCurrentTime:(NSInteger)time {
    [self.maskView.playerProgressView updateStartTime:time];
}

/** 完整的描述请参见文件头部 */
- (void)updateTotalTime:(NSInteger)time {
    [self.maskView.playerProgressView updateTotalTime:time];
}

/** 完整的描述请参见文件头部 */
- (void)updateSliderValue:(CGFloat)value {
    [self.maskView.playerProgressView updateSliderValue:value];
}

/** 完整的描述请参见文件头部 */
- (BOOL)isHiddenBottomView {
    return self.maskView.playerProgressView.hidden;
}

/** 完整的描述请参见文件头部 */
- (void)hiddenBottomView:(BOOL)hidden {
    self.maskView.playerProgressView.hidden = hidden;
    self.maskView.fullScreenButton.hidden = hidden;
}

#pragma mark - CJPlayerMaskViewDelegate
- (void)cjPlayerMaskView:(CJPlayerMaskView *)maskView fullScreenButtonClicked:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cjPlayerView:fullScreenButtonClicked:)]) {
        [self.delegate cjPlayerView:self fullScreenButtonClicked:button];
    }
}

- (void)cjPlayerMaskView:(CJPlayerMaskView *)maskView sliderValueChange:(CJPlayerSlider *)slider {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cjPlayerView:sliderValueChange:)]) {
        [self.delegate cjPlayerView:self sliderValueChange:slider];
    }
}

- (void)cjPlayerMaskView:(CJPlayerMaskView *)maskView sliderTouchBegan:(CJPlayerSlider *)slider {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cjPlayerView:sliderTouchBegan:)]) {
        [self.delegate cjPlayerView:self sliderTouchBegan:slider];
    }
}

- (void)cjPlayerMaskView:(CJPlayerMaskView *)maskView sliderTouchEnd:(CJPlayerSlider *)slider {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cjPlayerView:sliderTouchEnd:)]) {
        [self.delegate cjPlayerView:self sliderTouchEnd:slider];
    }
}

- (void)cjPlayerMaskView:(CJPlayerMaskView *)maskView touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cjPlayerView:touchesBegan:withEvent:)]){
        [self.delegate cjPlayerView:self touchesBegan:touches withEvent:event];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  CJPlayerMaskView.m
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJPlayerMaskView.h"
#import <PureLayout/PureLayout.h>

@interface CJPlayerMaskView ()<CJPlayerSliderDelegate>

@property (nonatomic, assign) CJPlayerMaskViewType maskViewType;

@property (nonatomic, strong) NSLayoutConstraint *progressBarConstraint;

@end


@implementation CJPlayerMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        _playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_play_normal"]];
        _playImageView.hidden = YES;
        [self addSubview:_playImageView];
        _playImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [_playImageView autoCenterInSuperview];
        
        _loadingView = [[CJLoadingProgressView alloc] init];
        _loadingView.hidden = YES;
        [self addSubview:_loadingView];
        _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
        [_loadingView autoCenterInSuperview];
        
        _playerProgressView = [[CJPlayerProgressView alloc] initWithFrame:CGRectZero];
        _playerProgressView.hidden = YES;
        _playerProgressView.playerSliderDelegate = self;
        [self addSubview:self.playerProgressView];
        _playerProgressView.translatesAutoresizingMaskIntoConstraints = NO;
        [_playerProgressView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        self.progressBarConstraint =  [_playerProgressView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:42.0];
        [_playerProgressView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [_playerProgressView autoSetDimension:ALDimensionHeight toSize:42.0f];
        
        _fullScreenButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_fullScreenButton setImage:[UIImage imageNamed:@"btn_fullScreen_normal"] forState:UIControlStateNormal];
        [_fullScreenButton setImage:[UIImage imageNamed:@"btn_closeFullScreen_normal"] forState:UIControlStateSelected];
        [_fullScreenButton addTarget:self action:@selector(fullScreenButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_fullScreenButton];
        _fullScreenButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_fullScreenButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
        [_fullScreenButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_fullScreenButton autoSetDimensionsToSize:CGSizeMake(32.0f, 32.0f)];
    }
    return self;
}

/** 完整的描述请参见文件头部 */
- (void)resetMaskViewWithMaskViewType:(CJPlayerMaskViewType)maskType {
    self.maskViewType = maskType;
    
    //重置时候去除事件
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setProgressViewHidden) object:nil];
    
    if (self.playImageView) {
        self.playImageView.hidden = YES;
    }
    
    if (self.loadingView) {
        self.loadingView.hidden = YES;
    }
    
    [self.playerProgressView resetValue];
    if (CJPlayerMaskViewTypeNormal == maskType) {
        self.playerProgressView.hidden = NO;
        self.fullScreenButton.hidden = NO;
        
        [self.progressBarConstraint autoRemove];
        self.progressBarConstraint = [self.playerProgressView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:42.0f];
        
    } else if (CJPlayerMaskViewTypeProgressOnly == maskType) {
        self.playerProgressView.hidden = NO;
        self.fullScreenButton.hidden = YES;
        
        [self.progressBarConstraint autoRemove];
        self.progressBarConstraint = [self.playerProgressView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
        
    } else {
        self.playerProgressView.hidden = YES;
        self.fullScreenButton.hidden = NO;
        
        [self.progressBarConstraint autoRemove];
        self.progressBarConstraint = [self.playerProgressView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:42.0f];
    }
    
    [self layoutIfNeeded];
}

/**
 *  全屏按钮点击
 *
 *  @param button 按钮
 */
- (void)fullScreenButtonClicked:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cjPlayerMaskView:fullScreenButtonClicked:)]) {
        [self.delegate cjPlayerMaskView:self fullScreenButtonClicked:button];
    }
}


#pragma mark Slider的委托
- (void)cjPlayerSliderValueChanged:(CJPlayerSlider *)playerSlider {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cjPlayerMaskView:sliderValueChange:)]) {
        [self.delegate cjPlayerMaskView:self sliderValueChange:playerSlider];
    }
}

- (void)cjPlayerSliderTouchDown:(CJPlayerSlider *)playerSlider {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setProgressViewHidden) object:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cjPlayerMaskView:sliderTouchBegan:)]) {
        [self.delegate cjPlayerMaskView:self sliderTouchBegan:nil];
    }
}

- (void)cjPlayerSliderTouchUp:(CJPlayerSlider *)playerSlider {
    [self performSelector:@selector(setProgressViewHidden) withObject:nil afterDelay:s_kProgressViewHideTime];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cjPlayerMaskView:sliderTouchEnd:)]) {
        [self.delegate cjPlayerMaskView:self sliderTouchEnd:nil];
    }
}


#pragma mark - touchEvent
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setProgressViewHidden) object:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cjPlayerMaskView:touchesBegan:withEvent:)]) {
        [self.delegate cjPlayerMaskView:self touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self performSelector:@selector(setProgressViewHidden) withObject:nil afterDelay:s_kProgressViewHideTime];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self performSelector:@selector(setProgressViewHidden) withObject:nil afterDelay:s_kProgressViewHideTime];
    
}

#pragma mark 隐藏进度条
- (void)setProgressViewHidden {
    self.playerProgressView.hidden = YES;
    self.fullScreenButton.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

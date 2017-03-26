//
//  CJPlayerController.m
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJPlayerController.h"

#import "CJPlayerViewController.h"
#import "CJMediaPlayer.h"
#import "CJPlayerSlider.h"
#import "CJPlayerManager.h"
//#import "MTPlayerNetwork.h"

@interface CJPlayerController () <CJPlayerViewDelegate, CJPlayerManagerDelegate> {
    
}
@property (nonatomic, assign, getter = isSliderDragging) BOOL sliderDragging;
@property (nonatomic, strong) CJPlayerManager *manager;
@property (nonatomic, assign) CJMediaPlayerStatus lastStatusOnWindow;

@property (nonatomic, strong) UIViewController *currentFullscreenViewController;

@end

@implementation CJPlayerController

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    _manager = [CJPlayerManager sharePlayerManager];
    
    _view = [[CJPlayerView alloc] initWithPlayerView:_manager.videoView];
    _view.delegate = self;
}

- (void)dealloc {
//    [self.playerView removeFromSuperview];
    [self reset];
}

- (void)didMoveToWindow {
    if (self.view.window == nil) {
        self.lastStatusOnWindow = self.manager.status;
        [self.manager pause];
    } else {
        if (self.lastStatusOnWindow == CJMediaPlayerStatusPlaying) {
            [self.manager play];
        }
    }
}


#pragma mark - set url
/** 完整的描述请参见文件头部 */
- (void)setVideoURL:(NSURL *)videoURL
         coverImage:(UIImage *)coverImage
          needCache:(BOOL)needCache
           maskType:(CJPlayerMaskViewType)maskType
{
    [self setFullScreen:NO animated:YES completion:nil];
    [self.view resetPlayerViewWithMaskViewType:maskType coverImage:coverImage];
    
    [[CJPlayerManager sharePlayerManager] setPlayIdentify:nil
                                                  playURL:videoURL
                                                needCache:needCache
                                                  preload:[videoURL absoluteString]
                                                 delegate:self];
}

/**
 *  展开和关闭全屏播放
 *
 *  @param full       是否需要全屏播放
 *  @param animated   是都添加展开全屏动画
 *  @param completion 设置完成后执行的内容
 */
- (void)setFullScreen:(BOOL)full animated:(BOOL)animated completion:(void (^)(void))completion {
    if (self.fullscreen == full) {
        return;
    }
    
    if (full) {
        UIViewController *currentController = [self firstAvailableUIViewController];
        CJPlayerViewController *containerController = [[CJPlayerViewController alloc] initWithPlayerController:self];
        [containerController presentFromViewController:currentController animated:animated completion:^{
            self.fullscreen = YES;
            [self.view showWithFullScreen:self.fullscreen];
            self.currentFullscreenViewController = containerController;
            
            if (completion) {
                completion();
            }
        }];
    } else {
        [self.currentFullscreenViewController dismissViewControllerAnimated:animated completion:^{
            self.fullscreen = NO;
            [self.view showWithFullScreen:self.fullscreen];
            
            if (completion) {
                completion();
            }
        }];
    }
}

- (UIViewController *)firstAvailableUIViewController {
    id nextResponder = [self.view nextResponder];
    
    while (nextResponder) {
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return nextResponder;
        } else if (![nextResponder isKindOfClass:[UIViewController class]] &&
                   ![nextResponder isKindOfClass:[UIView class]]) {
            /*  根据文档：
             UIView          的nextResponder是它的controller或superview；
             UIViewController的nextResponder是它view的superview；
             UIWindow        的nextResponder是UIApplication对象；
             UIApplication   的nextResponder是nil。
             
             因此当responder不是UIView或UIViewController之一时，无需再进行剩下的操作
             */
            break;
        }
        nextResponder = [nextResponder nextResponder];
    }
    return nil;
}


#pragma mark - CJPlayerManagerDelegate
/**
 *  播放状态改变回调
 *
 *  @param playerManager 播放管理器
 *  @param status        播放状态
 */
- (void)playerManager:(CJPlayerManager *)playerManager statusDidChanged:(CJMediaPlayerStatus)status {
    NSLog(@"playerManagerStatus = %d", (int)status);
    // 调整loading view状态
    [self showLoadingAnimationView:status];
    // 调整cover 状态
    if (status == CJMediaPlayerStatusPlaying) {
        [self.view hiddenCoverImageView];
    }
}

/**
 *  播放时间改变回调
 *
 *  @param playerManager 播放管理器
 *  @param time          时间
 */
- (void)playerManager:(CJPlayerManager *)playerManager progressDidChange:(CGFloat)progress {
    NSTimeInterval totalTime = [[CJMediaPlayer shared] duration];
    [self.view updateCurrentTime:(NSInteger)(totalTime * progress)];
    [self.view updateTotalTime:(NSInteger)totalTime];
    
    if (!_sliderDragging) {
        [self.view updateSliderValue:progress];
    }
}

/**
 *  用于保存播放视图状态，用于恢复播放视图
 *
 *  @param playerManager 播放管理器
 *  @param restoreDic    播放视图状态数据(out)
 */
- (void)playerManager:(CJPlayerManager *)playerManager saveRestoreDic:(NSMutableDictionary *)restoreDic {
    
}

/**
 *  播放状态出错
 */
- (void)playerManager:(CJPlayerManager *)playerManager loadFailed:(NSError *)error {
    
}


#pragma mark  MPPlayerViewDelegate
- (void)cjPlayerView:(CJPlayerView *)playerView sliderValueChange:(CJPlayerSlider *)slider {
    self.sliderDragging = YES;
    
    [self updateUIWithSeekForPercent:slider.value completion:NULL];
}

- (void)cjPlayerView:(CJPlayerView *)playerView sliderTouchBegan:(CJPlayerSlider *)slider {
    self.sliderDragging = YES;
    
    [self.manager willStartSeek];
}

- (void)cjPlayerView:(CJPlayerView *)playerView sliderTouchEnd:(CJPlayerSlider *)slider {
    self.sliderDragging = NO;
    
    [self.manager didEndSeek];
    if (self.manager.status == CJMediaPlayerStatusLoading) {
        [self showLoadingAnimationView:CJMediaPlayerStatusLoading];
    }
}

- (void)cjPlayerView:(CJPlayerView *)playerView fullScreenButtonClicked:(UIButton *)button {
    [self setFullScreen:!self.fullscreen animated:YES completion:nil];
}

- (void)cjPlayerView:(CJPlayerView *)playerView touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 播放时, 从隐藏状态展开进度条不会停止播放
    BOOL progressViewToogled = NO;
    if ([self.view isHiddenBottomView]) {
        [self.view hiddenBottomView:NO];
        progressViewToogled = YES;
    }
    
    CJMediaPlayer *player = [CJMediaPlayer shared];
    if (player.status == CJMediaPlayerStatusPlaying) {
        if (progressViewToogled) {
            return;
        }
        [player pause];
        [self.view hiddenplayImageView:NO];
    } else {
        [player play];
        [self.view hiddenplayImageView:YES];
    }
}


/**
 * 播放器加载视图的显隐
 */
- (void)showLoadingAnimationView:(CJMediaPlayerStatus)status{
    //BOOL bValue = CJMediaPlayerStatusLoading == status && !self.sliderDragging;
    //NSLog(@"showLoading ? %@, StatusLoading = %@, sliderDragging = %@", bValue ? @"YES":@"NO", CJMediaPlayerStatusLoading == status?@"YES":@"NO", self.sliderDragging ? @"YES":@"NO");
    if (CJMediaPlayerStatusLoading == status && !self.sliderDragging) {
        [self.view setLoadingImageViewStatus:YES];
        
        // TODO 播放器提示,等播放器状态搞完后再改这块
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            [self.loadingView stopAnimating];
        //            self.loadingView.hidden = YES;
        //            self.networkErrorView.hidden = NO;
        //
        //        });
    }
    else{
        [self.view setLoadingImageViewStatus:NO];
    }
}






#pragma mark API
- (void) play {
    [self.manager play];
}

- (void) pause {
    [self.manager pause];
}

- (void)seekToPercentDiscretely:(float)percent completion:(void (^)(BOOL))completion {
    [self.manager willStartSeek];
    [self updateUIWithSeekForPercent:percent completion:completion];
    [self.manager didEndSeek];
}

- (void)reset {
    [self.manager reset];
}

- (NSTimeInterval)duration {
    return [self.manager duration];
}

- (void)updateUIWithSeekForPercent:(float)percent completion:(void (^)(BOOL finished))completion {
    NSTimeInterval totalTime = [[CJMediaPlayer shared] duration];
    [self.view updateCurrentTime:(NSInteger)(totalTime * percent)];
    
    [self.manager seekToPercent:percent completion:completion];
}



@end

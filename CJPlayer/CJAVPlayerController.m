//
//  CJAVPlayerController.m
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/9.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJAVPlayerController.h"

#import <CJMediaCacheKit/CJAVCacheKit.h>


NSString *const kMTVideoKVOPath_Status                      = @"status";
NSString *const kMTVideoKVOPath_LoadedTimeRanges            = @"loadedTimeRanges";
NSString *const kMTVideoKVOPath_PlaybackBufferEmpty         = @"playbackBufferEmpty";
NSString *const kMTVideoKVOPath_PlaybackLikelyToKeepUp      = @"playbackLikelyToKeepUp";


@interface CJAVPlayerController ()


@property (nonatomic, strong) CJAVAssetResourceLoaderManager *loaderManager;

@property (nonatomic, strong) AVPlayer       *curPlayer;                    //当前播放器
@property (nonatomic, strong) AVPlayerItem   *curPlayerItem;                //当前playerItem
@property (nonatomic, weak  ) CJAVPlayerView *curPlayerView;                //当前PlayerView

@property (nonatomic, strong) AVURLAsset     *videoURLAsset;                //网络视频


@property (nonatomic, assign) CGFloat        duration;                      //视频总时间
@property (nonatomic, assign) CGFloat        current;                       //当前播放时间
@property (nonatomic, assign) CGFloat        progress;                      //播放进度(0~1)
@property (nonatomic, assign) BOOL          stopWhenAppDidEnterBackground;  //后台是否停止播放

@property (nonatomic, strong) NSObject       *playbackTimeObserver;


@property (nonatomic, assign) BOOL           isPauseByUser;                 //是否被用户暂停

@end

@implementation CJAVPlayerController


+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static id _sInstance;
    dispatch_once(&onceToken, ^{
        
        _sInstance = [[self alloc] init];
    });
    
    return _sInstance;
}



- (void)dealloc
{
    [self.curPlayer pause];
    [self releasePlayer];
    
    self.curPlayer = nil;
    self.loaderManager = nil;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //1 重置
        [self reset];
        
        //2 初始化
        self.loaderManager = [[CJAVAssetResourceLoaderManager alloc] init];
        
        
        
        __weak typeof(self) weakSelf = self;
        self.loaderManager.resourceLoadFailed = ^(NSError *err){
            
            
            NSLog(@"***************************");
            NSLog(@"err = %@", err);
            NSLog(@"***************************");
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络错误"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            
            weakSelf.curPlayerView.playerStatus = CJAVPlayerStateUnStart;
            
            
        };
        
        self.loaderManager.resourceNotExist = ^{
            
            NSLog(@"***************************");
            NSLog(@"文件不存在");
            NSLog(@"***************************");
            
            weakSelf.curPlayerView.playerStatus = CJAVPlayerStateUnStart;
            
        };
        
    }
    return self;
}


//重置
- (void)reset
{

    //播放器界面
    _curPlayerView.player       = nil;
    _curPlayerView              = nil;

    //播放器相关
    _videoURLAsset              = nil;
    _curPlayerItem              = nil;
    _curPlayer                  = nil;

    _duration                   = 0;
    _current                    = 0;

    
    //其他
    _isPauseByUser  = YES;
    _playbackTimeObserver = nil;
    
    //是否后台时停止播放
    _stopWhenAppDidEnterBackground = YES;

}


//释放player
- (void)releasePlayer
{
    if (self.curPlayerItem) {
        
        //1 暂停播放
        [self.curPlayer pause];
        
        //2 移除所有KVO和通知
        [self removeAllObserver];
        
        //3 重置
        [self reset];
        
    }
    
    //清理
    [self.loaderManager clean];
}




#pragma mark - 播放器操作(播放，暂停，停止)

- (void)playWithMediaUrl:(NSURL *)URL OnPlayerView:(CJAVPlayerView *)playerView
{

    //清理上次播放的相关东西
    [self releasePlayer];

    self.curPlayerView      = playerView;
    
    if ([URL.scheme isEqualToString:@"http"] || [URL.scheme isEqualToString:@"https"]) {
        NSLog(@"这是一个网络文件");
        //1 创建AVURLAsset
        NSURL *fakeUrl          = [CJAVUtil fakeUrl:URL];
        self.videoURLAsset      = [AVURLAsset URLAssetWithURL:fakeUrl options:nil];
        [self.videoURLAsset.resourceLoader setDelegate:self.loaderManager queue:dispatch_get_main_queue()];
        
        //2 创建AVPlayerItem
        self.curPlayerItem = [AVPlayerItem playerItemWithAsset:self.videoURLAsset];
        self.curPlayer     = [AVPlayer playerWithPlayerItem:self.curPlayerItem];
        
    } else if ([URL.scheme isEqualToString:@"file"]) {
        NSLog(@"这是一个本地文件");
        self.curPlayer     = [AVPlayer playerWithURL:URL];
    } else {
        NSLog(@"未知的URL类型");
    }
    
    playerView.player  = self.curPlayer;

    //添加所有观察
    [self addAllObserver];
    
    //开始播放
    [self.curPlayer play];

    self.curPlayerView.playerStatus = CJAVPlayerStateBuffering;

}



//播放
- (void)resume
{
    if (!self.curPlayerItem) {
        return;
    }
    
    self.isPauseByUser = NO;
    [self.curPlayer play];
    
    //缓冲
    self.curPlayerView.playerStatus = CJAVPlayerStateBuffering;
}


//暂停
- (void)pause
{
    if (!self.curPlayerItem) {
        return;
    }

    self.isPauseByUser = YES;
    [self.curPlayer pause];
    
    //暂停
    self.curPlayerView.playerStatus = CJAVPlayerStatePause;
}


//滑动暂停
- (void)slidePause
{
    if (!self.curPlayerItem) {
        return;
    }
    
    self.isPauseByUser = YES;
    [self.curPlayer pause];
    
    //暂停
    self.curPlayerView.playerStatus = CJAVPlayerStateSlidePause;
}



//停止
- (void)stop
{
    
    //停止(先设置状态，请清理)
    self.curPlayerView.playerStatus = CJAVPlayerStateUnStart;
    
    [self releasePlayer];
}



- (void)seekToTime:(CGFloat)seconds
{
    
    if (self.curPlayerView.playerStatus == CJAVPlayerStateUnStart) {
        return;
    }
    
    seconds = MAX(0, seconds);
    seconds = MIN(seconds, self.duration);
    
    //[self.curPlayer pause];
    
    __weak typeof(self) weakSelf = self;
    [self.curPlayer seekToTime:CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
        
        
        if (weakSelf.curPlayerView.playerStatus != CJAVPlayerStatePause) {
           
            weakSelf.isPauseByUser = NO;
            [weakSelf.curPlayer play];
            
            if (!weakSelf.curPlayerItem.isPlaybackLikelyToKeepUp) {
                
                //通知UI正在缓冲
                weakSelf.curPlayerView.playerStatus = CJAVPlayerStateBuffering;
                
            } else {
                
                weakSelf.curPlayerView.playerStatus = CJAVPlayerStatePlaying;
            }
            
        }
    }];
}




#pragma mark - Private

- (void)removeAllObserver
{
    //Notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //KVO
    [self.curPlayerItem removeObserver:self forKeyPath:kMTVideoKVOPath_Status];
    [self.curPlayerItem removeObserver:self forKeyPath:kMTVideoKVOPath_LoadedTimeRanges];
    [self.curPlayerItem removeObserver:self forKeyPath:kMTVideoKVOPath_PlaybackBufferEmpty];
    [self.curPlayerItem removeObserver:self forKeyPath:kMTVideoKVOPath_PlaybackLikelyToKeepUp];
    
    //TimeObserver
    [self.curPlayer removeTimeObserver:self.playbackTimeObserver];
}


- (void)addAllObserver
{
    
    //KVO
    [self.curPlayerItem addObserver:self forKeyPath:kMTVideoKVOPath_Status options:NSKeyValueObservingOptionNew context:nil];
    [self.curPlayerItem addObserver:self forKeyPath:kMTVideoKVOPath_LoadedTimeRanges options:NSKeyValueObservingOptionNew context:nil];
    [self.curPlayerItem addObserver:self forKeyPath:kMTVideoKVOPath_PlaybackBufferEmpty options:NSKeyValueObservingOptionNew context:nil];
    [self.curPlayerItem addObserver:self forKeyPath:kMTVideoKVOPath_PlaybackLikelyToKeepUp options:NSKeyValueObservingOptionNew context:nil];
    
    
    //Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.curPlayerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemPlaybackStalled:) name:AVPlayerItemPlaybackStalledNotification object:self.curPlayerItem];
}



#pragma mark - 通知

- (void)appDidEnterBackground
{
    if (self.stopWhenAppDidEnterBackground) {
        
        [self pause];
        self.isPauseByUser = NO;
    }
}

- (void)appDidEnterForeground
{
    if (!self.isPauseByUser) {
        [self resume];
    }
}

- (void)playerItemDidPlayToEnd:(NSNotification *)notification
{
    NSLog(@"播放结束");
    [self stop];
}


- (void)playerItemPlaybackStalled:(NSNotification *)notification
{
    //网络不好的时候，就会进入，不做处理.
    //会在playbackBufferEmpty里面缓存之后重新播放
    NSLog(@"缓冲");
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:kMTVideoKVOPath_Status]) {
        
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            
            //给播放器添加计时器
           self.curPlayerView.playerStatus = CJAVPlayerStatePlaying;
            [self monitoringPlayback:playerItem];
            
        } else if ([playerItem status] == AVPlayerStatusFailed || [playerItem status] == AVPlayerStatusUnknown) {
            
            //播放失败
            [self stop];
        }
        
    } else if ([keyPath isEqualToString:kMTVideoKVOPath_LoadedTimeRanges]) {
        
        //监听播放器的下载进度

        
    } else if ([keyPath isEqualToString:kMTVideoKVOPath_PlaybackBufferEmpty]) {
        
        //监听播放器在缓冲数据的状态
        if (playerItem.isPlaybackBufferEmpty) {
            
            //缓冲几秒
            self.curPlayerView.playerStatus = CJAVPlayerStateBuffering;
            [self bufferingSomeSecond];

        }
    }
}






- (void)monitoringPlayback:(AVPlayerItem *)playerItem
{
    
    //视频总时间
    self.duration = playerItem.duration.value / playerItem.duration.timescale;

    //开始播放
    [self.curPlayer play];
    
    [self.curPlayerView updateTotalTime:self.duration];
    [self.curPlayerView setPlaySliderMaxValue:self.duration];


    __weak __typeof(self) weakSelf = self;
    
    self.playbackTimeObserver = [self.curPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        CGFloat current = playerItem.currentTime.value/playerItem.currentTime.timescale;
        
        [strongSelf.curPlayerView updateCurrentTime:current];
        [strongSelf.curPlayerView updateProgressSlider:current];
        

        if (strongSelf.isPauseByUser == NO) {
            strongSelf.curPlayerView.playerStatus = CJAVPlayerStatePlaying;
        }
        
        //不相等的时候才更新
        if (strongSelf.current != current) {

            strongSelf.current = current;
            if (strongSelf.current > strongSelf.duration) {
                strongSelf.duration = strongSelf.current;
            }
        }
        
    }];
    
}





#pragma mark - Property

//播放进度
- (CGFloat)progress
{
    if (self.duration > 0) {
        
        return self.current / self.duration;
    }
    
    return 0;
}




#pragma mark - Util


- (void)bufferingSomeSecond
{
    //playbackBufferEmpty时会反复进入这里，
    //因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    static BOOL isBuffering = NO;
    if (isBuffering) {
        return;
    }
    isBuffering = YES;
    
    //需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    __weak typeof(self) weakSelf = self;
    [self.curPlayer pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (weakSelf.isPauseByUser) {
            isBuffering = NO;
            return;
        }
        
        [weakSelf.curPlayer play];
        
        //如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        if (!weakSelf.curPlayerItem.isPlaybackLikelyToKeepUp) {
            [weakSelf bufferingSomeSecond];
        }
    });
}





@end

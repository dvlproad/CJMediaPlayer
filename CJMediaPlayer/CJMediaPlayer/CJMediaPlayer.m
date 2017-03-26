//
//  CJMediaPlayer.m
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJMediaPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "TransitionKit.h"

//#import "MCResourceLoaderManager.h"
#import "CJAVAssetResourceLoaderManager.h"
#import "CJAVUtil.h"

#define MPIOSVersion ([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] firstObject] floatValue])

static NSString *const EndStateName = @"End";
static NSString *const StopStateName = @"Stop";
static NSString *const LoadingStateName = @"Loading";
static NSString *const PlayingStateName = @"Playing";
static NSString *const PauseStateName = @"Paused";

static NSString *const LoadEventName = @"Load Media";
static NSString *const PlayEventName = @"Play Media";
static NSString *const ReplayEventName = @"Replay Media";
static NSString *const PauseEventName = @"Pause Media";
static NSString *const StopEventName = @"Stop Media";
static NSString *const EndEventName = @"End Media";

static NSString *const Tracks = @"tracks";

static const NSString *ItemLoadedTimeRangesContext;
static const NSString *MediaPlayerStatusContext;
static const NSString *AVPlayerRateContext;
static const NSString *AVPlayerItemStatusContext;

static const NSTimeInterval kBufferDuration = 2.0f;
static const NSTimeInterval kReachEndBoundDuration = 0.5f;
static const NSTimeInterval kTimeoutDuration = 60.f;

@interface CJMediaPlayer ()

@property(strong, nonatomic) AVPlayer *player;
@property(strong, nonatomic) AVPlayerItem *playerItem;
@property(strong, nonatomic) CJVideoView *videoView;
@property(strong, nonatomic) id playerObserver;
@property(strong, nonatomic) TKStateMachine *stateMachine;

@property(assign, nonatomic, getter = isWillSeeking) BOOL willSeeking;
@property(assign, nonatomic, getter = isSeeking) BOOL seeking;

@property(nonatomic, assign) BOOL autoPlayAfterSeeking;

@property (nonatomic, strong) CJAVAssetResourceLoaderManager *resourceLoaderManager;/** update by lichq */

@end

@implementation CJMediaPlayer {
    /**
     *  加载超时定时器
     */
    NSTimer *_timeOutTimer;

    BOOL _background;

    /**
     *  可播放标记位，用于在Loading状态时，真正加载到2秒或者到结尾才开始播放
     */
    BOOL _canPlay;
}

- (void)dealloc {
    [_player removeObserver:self forKeyPath:@"rate" context:&AVPlayerRateContext];
    [self removeTimeObserverFromPlayer];
    [self removeObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"status" context:&MediaPlayerStatusContext];
}

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });

    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)addRouteChangeListener {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioRouteChangeNotification:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:nil];
}

- (void)audioRouteChangeNotification:(NSNotification *)notification {
    NSNumber *changeReason = notification.userInfo[AVAudioSessionRouteChangeReasonKey];

    if (changeReason.unsignedIntegerValue == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *route = notification.userInfo[AVAudioSessionRouteChangePreviousRouteKey];
        for (AVAudioSessionPortDescription *desc in [route outputs]) {
            if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones]) {
                [self fireEvent:PauseEventName userInfo:nil];           // 耳机拔掉暂停
                return;
            }
        }
    }
}


- (void)setUrl:(NSURL *)url withCache:(BOOL)needCache {
    _needCache = needCache;
    if (!needCache) {
        _url = url;
    }else {
        NSURL *fakeUrl = [CJAVUtil fakeUrl:url];
        _url = fakeUrl;
    }
}

#pragma mark - Private

- (void)commonInit {
    _autoPlayAfterSeeking = YES;

    self.videoView = [[CJVideoView alloc] init];

    [self addRouteChangeListener];
    self.stateMachine = [[TKStateMachine alloc] init];

    __weak typeof(self) weakSelf = self;
    TKState *end = [TKState stateWithName:EndStateName];
    [end setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        if ([weakSelf isPlaying]) {
            [weakSelf.player pause];
        }
        weakSelf.status = CJMediaPlayerStatusReachEnd;
        weakSelf.seeking = NO;
        //        NSLog(@"player did enter end");
    }];

    TKState *stop = [TKState stateWithName:StopStateName];
    [stop setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [weakSelf.player pause];
        [weakSelf.player.currentItem cancelPendingSeeks];
        [weakSelf.player cancelPendingPrerolls];
        if (weakSelf.player.error) {
            [weakSelf removeObserver];
            [weakSelf.player removeObserver:weakSelf forKeyPath:@"rate" context:&AVPlayerRateContext];
            [weakSelf removeTimeObserverFromPlayer];
            weakSelf.player = nil;
        }
        weakSelf.seeking = NO;
        [weakSelf removeObserver];
        weakSelf.playerItem = nil;
        weakSelf.status = CJMediaPlayerStatusUnknow;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf->_canPlay = NO; // 将可以播放标记位重置为NO
        //        NSLog(@"player did enter stop status");
    }];

    TKState *loading = [TKState stateWithName:LoadingStateName];
    [loading setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([transition.sourceState.name isEqualToString:StopStateName]) {
            [weakSelf loadMediaWithURL:weakSelf.url];
        }
        else if (![transition.sourceState.name isEqualToString:PlayingStateName]) {
            if (!strongSelf->_canPlay)     // 判断可播放状态为NO，检查下是否可播放
            {
                strongSelf->_canPlay = [weakSelf playerCouldStartPlay];
            }

            if ([weakSelf readyForPlay] && !weakSelf.isSeeking && strongSelf->_canPlay) {
                [weakSelf.player play];
            }
        }
        weakSelf.status = CJMediaPlayerStatusLoading;
        //        NSLog(@"player did enter loading status");
    }];

    [loading setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf->_timeOutTimer invalidate];
        strongSelf->_timeOutTimer = nil;
    }];

    TKState *playing = [TKState stateWithName:PlayingStateName];
    [playing setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [weakSelf.player play];
        weakSelf.status = CJMediaPlayerStatusPlaying;
        //        NSLog(@"player did enter playing status");
    }];

    TKState *pause = [TKState stateWithName:PauseStateName];
    [pause setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        if ([weakSelf isPlaying]) {
            [weakSelf.player pause];
        }

        weakSelf.status = CJMediaPlayerStatusPause;
        //        NSLog(@"player did enter pause status");
    }];

    [self.stateMachine addStates:@[loading, playing, pause, stop, end]];
    self.stateMachine.initialState = stop;

    TKEvent *loadMedia = [TKEvent eventWithName:LoadEventName transitioningFromStates:@[stop, end, pause, playing] toState:loading];
    TKEvent *playMedia = [TKEvent eventWithName:PlayEventName transitioningFromStates:@[loading] toState:playing];
    TKEvent *pauseMedia = [TKEvent eventWithName:PauseEventName transitioningFromStates:@[loading, playing] toState:pause];
    TKEvent *stopMedia = [TKEvent eventWithName:StopEventName transitioningFromStates:@[loading, playing, pause, end] toState:stop];
    TKEvent *unknowMedia = [TKEvent eventWithName:EndEventName transitioningFromStates:@[loading, playing] toState:end];
    TKEvent *replayMedia = [TKEvent eventWithName:ReplayEventName transitioningFromStates:@[end] toState:playing];

    [self.stateMachine addEvents:@[loadMedia, playMedia, pauseMedia, stopMedia, unknowMedia, replayMedia]];

    [self.stateMachine activate];

    [self addObserver:self
           forKeyPath:@"status"
              options:NSKeyValueObservingOptionNew
              context:&MediaPlayerStatusContext];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

- (void)loadMediaWithURL:(NSURL *)url {
    if (url.absoluteString.length == 0) {
        return;
    }
    // 取消上次加载的视频
    [self removeObserver];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    
    NSLog(@"self.needCache = %@", self.needCache ? @"YES" : @"NO");
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    if (self.needCache) { /** 使用缓存时候 */
        self.resourceLoaderManager = [[CJAVAssetResourceLoaderManager alloc] init];
        [asset.resourceLoader setDelegate:self.resourceLoaderManager queue:dispatch_get_main_queue()];
    }
    
    [asset loadValuesAsynchronouslyForKeys:@[Tracks] completionHandler: ^{
        //        NSLog(@"Load values completion");
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            NSError *error;
            AVKeyValueStatus status = [asset statusOfValueForKey:Tracks error:&error];
            NSLog(@"status1 = %ld meaning %@", status, status==3 ? @"Fail" : @"Success");
            if (![url isEqual:self.url])
            {
                //                NSLog(@"load delay error");
                return;
            }
            if (status == AVKeyValueStatusLoaded) {
                [self setupMediaPlayerWithAsset:asset];
            }
            else if (status == AVKeyValueStatusFailed) {
                //                NSLog(@"The asset's tracks were not loaded:\n%@", error.localizedDescription);
                if ([self.delegate respondsToSelector:@selector(player:loadFailed:)]) {
                    [self fireEvent:StopEventName userInfo:nil];
                    [self.delegate player:self loadFailed:error];
                }
            }
        });
    }];
}

- (void)setupMediaPlayerWithAsset:(AVURLAsset *)asset //lichq:AVAsset 改为了 AVURLAsset
{
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive)
    {
        return;
    }

    AVPlayerItem *item = nil;
    if (asset) {
        /*
        NSLog(@"self.needCache = %@", self.needCache ? @"YES" : @"NO");
        if (self.needCache) {
            MCResourceLoaderManager *resourceLoaderManager = [MCResourceLoaderManager new];
            self.resourceLoaderManager = resourceLoaderManager;
            resourceLoaderManager.cacheScheme = @"MTMediaCache";
            
            NSURL *url = asset.URL;
            NSURLComponents *componnents = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
            componnents.scheme = resourceLoaderManager.cacheScheme;
            
            // 添加 url 参数
            NSString *appendStr = componnents.queryItems.count > 0 ? @"&" : @"?";
            NSURL *newURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@MCurl=%@", componnents.string, appendStr, url.absoluteString]];
            url = newURL;
            self.url = url;
            asset = [[AVURLAsset alloc] initWithURL:url options:nil];
            [asset.resourceLoader setDelegate:resourceLoaderManager queue:dispatch_get_main_queue()];
            
            [asset loadValuesAsynchronouslyForKeys:@[Tracks] completionHandler: ^{
                //        NSLog(@"Load values completion");
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    NSError *error;
                    AVKeyValueStatus status = [asset statusOfValueForKey:Tracks error:&error];
                    NSLog(@"status2 = %ld meaning %@", status, status==3 ? @"Fail" : @"Success");
                });
            }];
//            AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:asset];
//            item.canUseNetworkResourcesForLiveStreamingWhilePaused = YES;
//            self.player = [AVPlayer playerWithPlayerItem:item];
//            [self.videoView setPlayer:self.player];
//            [self.player play];
//            return;
        }
//        */
        item = [[AVPlayerItem alloc] initWithAsset:asset];
        if (self.needCache) {
            item.canUseNetworkResourcesForLiveStreamingWhilePaused = YES;
        }
    }

    if (!self.player && item) {
        self.player = [[AVPlayer alloc] init];
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
        [self.player addObserver:self
                      forKeyPath:@"rate"
                         options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                         context:&AVPlayerRateContext];
        [self addTimeObserverToPlayer];
        [self.videoView setPlayer:self.player];
    }

    // remove old observer, update, setup new observer
    // if input is nil, we must clear out all old player item to avoid layer content flashing
    if (self.playerItem) {
        [self removeObserver];
    }
    if (item) {
        [self.player replaceCurrentItemWithPlayerItem:item];
        self.playerItem = item;
        [self addObserver];
    } else {
        [self.player removeObserver:self forKeyPath:@"rate" context:&AVPlayerRateContext];
        [self removeTimeObserverFromPlayer];
        [self.videoView setPlayer:nil];
        self.playerItem = nil;
        self.player = nil;
    }
}

- (void)addTimeObserverToPlayer {
    if (self.playerObserver) {
        return;
    }

    if (self.player == nil) {
        return;
    }

    if (self.player.currentItem.status != AVPlayerItemStatusReadyToPlay) {
        return;
    }

    double duration = CMTimeGetSeconds([self playerItemDuration]);

    if (isfinite(duration)) {
        __weak typeof(self) weakSelf = self;
        self.playerObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 20)
                                                                        queue:dispatch_get_main_queue()
                                                                   usingBlock:^(CMTime time) {
                                                                       [weakSelf timeChangeHandler:time];
                                                                   }];
    }
}

- (void)removeTimeObserverFromPlayer {
    if (self.playerObserver) {
        [self.player removeTimeObserver:self.playerObserver];
        self.playerObserver = nil;
    }
}

- (CMTime)playerItemDuration {
    AVPlayerItem *playerItem = [self.player currentItem];
    CMTime itemDuration = kCMTimeInvalid;

    if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
        itemDuration = [playerItem duration];
    }

    /* Will be kCMTimeInvalid if the item is not ready to play. */
    return itemDuration;
}


- (void)timeChangeHandler:(CMTime)time {
    if ([self isPlaying])   // 只处理正在播放时的时间变化
    {
        NSTimeInterval second = CMTimeGetSeconds(time);
        if (second > DBL_EPSILON && [self.stateMachine isInState:LoadingStateName]) {
            if ([self readyForPlay]) {
                [self fireEvent:PlayEventName userInfo:nil];
            }
        }
        if ([self.delegate respondsToSelector:@selector(player:timeDidChanged:)]) {
            [self.delegate player:self timeDidChanged:second];
        }
    }
}

- (NSTimeInterval)playableDuration {
    //  use loadedTimeRanges to compute playableDuration.
    AVPlayerItem *item = self.player.currentItem;

    if (item.status == AVPlayerItemStatusReadyToPlay) {
        NSArray *timeRangeArray = item.loadedTimeRanges;

        CMTimeRange aTimeRange = [[timeRangeArray lastObject] CMTimeRangeValue];

        double startTime = CMTimeGetSeconds(aTimeRange.start);
        double loadedDuration = CMTimeGetSeconds(aTimeRange.duration);

        return (NSTimeInterval) (startTime + loadedDuration);
    }
    else {
        return (CMTimeGetSeconds(kCMTimeInvalid));
    }
}

- (BOOL)playerCouldStartPlay {
    CMTimeRange timeRange = [[self.player.currentItem.loadedTimeRanges lastObject] CMTimeRangeValue];
    //    NSLog(@"LoadedRange %@", self.player.currentItem.loadedTimeRanges);
    NSTimeInterval loadedDuration = CMTimeGetSeconds(timeRange.duration);
    BOOL reachEnd = CMTimeGetSeconds(self.player.currentItem.duration) - [self playableDuration] < kReachEndBoundDuration;

    //    NSLog(@"loadedDuration %f", loadedDuration);
    return (loadedDuration > kBufferDuration || reachEnd);
}

- (void)playerItemDidUpdatedLoadedTimeRanges {
    if ([self playerCouldStartPlay]) {
        if ([self.stateMachine isInState:LoadingStateName]
                && !self.isSeeking) {
            if ([self readyForPlay]) {
                [self fireEvent:PlayEventName userInfo:nil];
            }
        }

        // 进度满足条件，设置可播放为YES
        _canPlay = YES;
    }
}

- (void)fireEvent:(NSString *)event userInfo:(NSDictionary *)userInfo {
    // 每次触发loading到重置加载超时定时器
    if ([event isEqualToString:LoadEventName]) {
        [_timeOutTimer invalidate];
        _timeOutTimer = [NSTimer scheduledTimerWithTimeInterval:kTimeoutDuration
                                                         target:self
                                                       selector:@selector(loadingTimeout)
                                                       userInfo:nil
                                                        repeats:NO];
    }
    NSError *error = nil;
    BOOL success = [self.stateMachine fireEvent:event userInfo:userInfo error:&error];
    if (!success) {
        //        NSLog(@"%@ failed error : %@", event, error);
    }
}

- (void)loadingTimeout {
    if ([self.stateMachine isInState:LoadingStateName]) {
        if ([self.delegate respondsToSelector:@selector(player:loadFailed:)]) {
            [self fireEvent:StopEventName userInfo:nil];
            NSError *error = self.player.currentItem.error;
            [self.delegate player:self loadFailed:error];
        }
    }
}

#pragma mark - Notification

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [self fireEvent:EndEventName userInfo:nil];
}

#pragma mark - Observer

- (void)addObserver {
    // Observe the player item "status" key to determine when it is ready to play
    [self.player.currentItem addObserver:self
                              forKeyPath:@"status"
                                 options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
                                 context:&AVPlayerItemStatusContext];
    [self.player.currentItem addObserver:self
                              forKeyPath:@"loadedTimeRanges"
                                 options:NSKeyValueObservingOptionNew
                                 context:&ItemLoadedTimeRangesContext];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.player.currentItem];
}

- (void)removeObserver {
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:&ItemLoadedTimeRangesContext];
    [self.player.currentItem removeObserver:self forKeyPath:@"status" context:&AVPlayerItemStatusContext];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (context == &ItemLoadedTimeRangesContext) {
        if (self.isWillSeeking) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self playerItemDidUpdatedLoadedTimeRanges];
        });
        return;
    }
    else if (context == &AVPlayerRateContext) {
        if (self.isWillSeeking) {
            return;
        }
        //        NSLog(@"Player rate change: %@", change);
        if (_background) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            float newRate = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
            NSNumber *oldRateNum = [change objectForKey:NSKeyValueChangeOldKey];
            if (![oldRateNum isKindOfClass:[NSNumber class]] || newRate == [oldRateNum floatValue]) {
                return;
            }
            if (![self isPlaying]) {
                CMTime currentTime = self.player.currentItem.currentTime;
                CMTime duration = self.player.currentItem.duration;
                if ([self.stateMachine isInState:PlayingStateName]              // 自动暂停
                        && CMTimeCompare(currentTime, duration) < 0)                // 播放到结尾
                {
                    [self fireEvent:LoadEventName userInfo:nil];
                }
            }
        });
        return;
    }
    else if (context == &MediaPlayerStatusContext) {
        if (self.isWillSeeking && self.status != CJMediaPlayerStatusReachEnd) {
            return;
        }
        if ([self.delegate respondsToSelector:@selector(player:statusDidChanged:)]) {
            [self.delegate player:self statusDidChanged:self.status];
        }
        return;
    }
    else if (context == &AVPlayerItemStatusContext) {
        if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            [self addTimeObserverToPlayer];
        }
        else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
            if ([self.delegate respondsToSelector:@selector(player:loadFailed:)]) {
                [self fireEvent:StopEventName userInfo:nil];
                NSError *error = self.player.currentItem.error;
                [self.delegate player:self loadFailed:error];
            }
        }
        return;
    }

    [super observeValueForKeyPath:keyPath
                         ofObject:object
                           change:change
                          context:context];
}

#pragma mark - Interface
- (BOOL) readyForPlay;
{
    if (![self.player.currentItem isEqual:self.playerItem]) {
        NSLog(@"![self.player.currentItem isEqual:self.playerItem]");
    }
    if (self.player.currentItem.status != AVPlayerItemStatusReadyToPlay) {
        NSLog(@"NO: self.player.currentItem.status != AVPlayerItemStatusReadyToPlay");
    }
    BOOL readyForDisPlay = [self readyForDisPlay];
    if (!readyForDisPlay) {
        NSLog(@"readyForDisPlay = %@", readyForDisPlay ? @"YES" : @"NO");
    }
    return [self.player.currentItem isEqual:self.playerItem]
    && self.player.currentItem.status == AVPlayerItemStatusReadyToPlay
    && readyForDisPlay;
}

- (BOOL) readyForDisPlay
{
    if (self.needCache) {
        return YES; /** TODO lichq */
    }else{
        if ([self.playerItem.asset tracksWithMediaType:AVMediaTypeVideo].count != 0)
        {
            NSError *error;
            AVKeyValueStatus status = [self.playerItem.asset statusOfValueForKey:Tracks error:&error];
            NSLog(@"status3 = %ld meaning %@", status, status==3 ? @"Fail" : @"Success");
            NSLog(@"url = %@", ((AVURLAsset *)self.playerItem.asset).URL);
            
            BOOL readyForDisplay = self.videoView.playerLayer.readyForDisplay;
            NSLog(@"readyForDisplay = %@", readyForDisplay ? @"YES" : @"NO");
            return readyForDisplay;
        }
        else
        {
            return YES;
        }
    }
}

- (void)replay {
    [self seekToPercent:0 completion:^(BOOL finished) {
        if (finished) {
            [self fireEvent:ReplayEventName userInfo:nil];
        }
    }];
}

- (void)play {
    if ([self.stateMachine isInState:LoadingStateName]
            || [self.stateMachine isInState:PlayingStateName]) {
        return;
    }
    [self fireEvent:LoadEventName userInfo:nil];
}

- (void)pause {
    if ([self.stateMachine isInState:PauseStateName] || [self.stateMachine isInState:EndStateName]) {
        return;
    }
    [self fireEvent:PauseEventName userInfo:nil];
}

- (void)willStartSeek {
    self.willSeeking = YES;
    if ([self.stateMachine isInState:PlayingStateName]) {
        [self.player pause];
        self.autoPlayAfterSeeking = YES;
    } else if ([self.stateMachine isInState:LoadingStateName]) {
        [self.player pause];
    } else {
        self.autoPlayAfterSeeking = NO;
    }
}

- (void)seekToPercent:(float)percent completion:(void (^)(BOOL finished))completion {
    if (![self.stateMachine isInState:PauseStateName]
            && ![self.stateMachine isInState:EndStateName]
            && ![self.stateMachine isInState:StopStateName]) {
        [self fireEvent:LoadEventName userInfo:nil];
    }
    CMTime duration = self.player.currentItem.duration;
    CMTime time = CMTimeMake(duration.value * percent, duration.timescale);
    self.seeking = YES;
    [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        if (![self.playerItem isEqual:self.player.currentItem]) {
            //            NSLog(@"asset do not match");
            self.willSeeking = NO;
            return;
        }
        self.seeking = !finished;

        if (completion) {
            completion(finished);
        }
    }];
}

- (void)didEndSeek {
    self.willSeeking = NO;
    if (self.autoPlayAfterSeeking) {
        [self.player play];
    }
}

- (void)reset {
    [self setupMediaPlayerWithAsset:nil];
    if ([self.stateMachine isInState:StopStateName]) {
        return;
    }
    [self fireEvent:StopEventName userInfo:nil];
}

- (BOOL)isPlaying; {
    return ABS(self.player.rate) > FLT_EPSILON;
}

- (NSTimeInterval)duration {
    if (self.player.currentItem) {
        return CMTimeGetSeconds(self.player.currentItem.duration);
    }
    return 0.f;
}

- (void)cancel {
    [_timeOutTimer invalidate];
    _timeOutTimer = nil;
}

#pragma mark - Notification

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    if (![self readyForPlay]) {
        CJMediaPlayerStatus status = self.status;
        [self fireEvent:StopEventName userInfo:nil];
        if (status == CJMediaPlayerStatusLoading
                || status == CJMediaPlayerStatusPlaying) {
            [self fireEvent:LoadEventName userInfo:nil];
        }
    }
    else if (_background && !self.isSeeking) {
        if (MPIOSVersion < 8) {
            // Hack Fix: iOS 7 下如果进入后台的时候，AVPlayerLayer 的视频 layer 没有加载的话，回来的时候，会导致视频灰屏，需要重置一下。
            if ([[[self.videoView.playerLayer sublayers] firstObject] sublayers].count == 0) {
                [self.videoView setPlayer:self.player];
            }
        }
        if (self.status == CJMediaPlayerStatusPlaying) {
            [self.player play];
        }
    }
    _background = NO;
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    if (self.status == CJMediaPlayerStatusPlaying
            || self.status == CJMediaPlayerStatusLoading) {
        _background = YES;
        [self.player pause];
    }
}

@end

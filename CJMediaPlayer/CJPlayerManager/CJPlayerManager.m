//
//  CJPlayerManager.m
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJPlayerManager.h"
#import "CJMediaPlayer.h"
#import "CJVideoView.h"

@interface CJPlayerManager () <CJMediaPlayerDelegate> {
    
}
@property (strong, nonatomic) CJMediaPlayer *mediaPlayer;
@property (strong, nonatomic) NSURL *url;

@property(assign, nonatomic) BOOL needResumeWhenBecomeActive;
@property(assign, nonatomic) BOOL playWhileSeek;
@property(assign, nonatomic) NSUInteger playCount;
@property(assign, nonatomic) CGFloat progress;

@property(copy, nonatomic) NSString *playIdentify;
@property(copy, nonatomic) NSString *preload;

@property(weak, nonatomic) id <CJPlayerManagerDelegate> delegate;

@end

@implementation CJPlayerManager {
    NSMutableDictionary *_mutableRestoreDic;
}

@synthesize restoreDic = _mutableRestoreDic;

/**
 *  获取单例
 *
 *  @return 单例
 */
+ (instancetype)sharePlayerManager {
    static CJPlayerManager *_sharePlayerManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharePlayerManager = [[self alloc] init];
    });

    return _sharePlayerManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _mediaPlayer = [CJMediaPlayer shared];
        _mediaPlayer.delegate = self;
        _mutableRestoreDic = [NSMutableDictionary new];
    }
    return self;
}


- (NSTimeInterval)duration {
    return [self.mediaPlayer duration];
}

#pragma mark - Interface

/**
 *  配置播放信息，只有当Unknown尝试播放才调用
 *
 *  @param playIdentify 播放标识
 *  @param url          播放url
 *  @param needCache    是否需要缓存
 *  @param preload      预加载url
 *  @param delegate     代理
 */
- (void)setPlayIdentify:(NSString *)playIdentify
                playURL:(NSURL *)url
              needCache:(BOOL)needCache
                preload:(NSString *)preload
               delegate:(id <CJPlayerManagerDelegate>)delegate {

    [self reset];
    self.playIdentify = playIdentify;
    self.url          = url;
    self.preload      = preload;
    self.delegate     = delegate;
    
    [self.mediaPlayer setUrl:url withCache:needCache];
}

/**
 *  当前播放标识的播放状态
 *
 *  @param playIdentify 播放标识
 *
 *  @return 播放状态
 */
- (CJMediaPlayerStatus)status {
    return self.mediaPlayer.status;
}

/**
 *  判断manager是否和相应的playIdentify link
 *
 *  @param playIdentify
 */
- (BOOL)isLinkedWithPlayIdentify:(NSString *)playIdentify {
    return [self.playIdentify isEqualToString:playIdentify];
}

/**
 *  返回videoView
 *
 *  @return
 */
- (CJVideoView *)videoView {
    return self.mediaPlayer.videoView;
}

- (void)willStartSeek {
    [self.mediaPlayer willStartSeek];
}

- (void)endSeekOnValue:(float)value {
    __weak typeof(self) weakSelf = self;
    [self seekToPercent:value completion:^(BOOL finished) {
        weakSelf.progress = value;
    }];
}

- (void)didEndSeek {
    [self.mediaPlayer didEndSeek];
}

/**
 *  seek到当前百分比
 *
 *  @param percent 百分比
 */
- (void)seekToPercent:(float)percent completion:(void (^)(BOOL finished))completion {
    [self.mediaPlayer seekToPercent:percent completion:completion];
}

/**
 *  调用播放
 */
- (void)play {
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        return;
    }
    if (self.url.absoluteString.length) {
        [self.mediaPlayer play];
    }
    else {
        if ([self.delegate respondsToSelector:@selector(playerManager:loadFailed:)]) {
            [self.delegate playerManager:self loadFailed:nil];  // url为nil，不调用播放，直接拦截
        }
        [self reset];
    }
}

/**
 *  调用停止
 */
- (void)pause {
    [self.mediaPlayer pause];
}

/**
 *  重置
 */
- (void)reset {
    [self.mediaPlayer reset];
    self.loopPlay = NO;
    self.playCount = 0;
    self.delegate = nil;
    self.playIdentify = nil;
    self.progress = 0.f;
    [self resetRestoreDic];
}

- (void)updateDelegate:(id <CJPlayerManagerDelegate>)delegate; {
    if ([self.delegate respondsToSelector:@selector(playerManager:saveRestoreDic:)]) {
        [self.delegate playerManager:self saveRestoreDic:_mutableRestoreDic];
    }
    self.delegate = delegate;
}

/**
 *  重置播放视图恢复字典，播放视图恢复过之后，重置这个字典。防止错误重置
 */
- (void)resetRestoreDic; {
    [_mutableRestoreDic removeAllObjects];
}

#pragma mark - CJMediaPlayerDelegate

- (void)player:(CJMediaPlayer *)player statusDidChanged:(CJMediaPlayerStatus)status {
    if (CJMediaPlayerStatusReachEnd == status) {
        self.progress = 0.f;
        ++self.playCount;
    }
    if (CJMediaPlayerStatusReachEnd == status && self.loopPlay) {
        [self.mediaPlayer replay];
        if ([self.delegate respondsToSelector:@selector(playerManager:statusDidChanged:)]) {
            [self.delegate playerManager:self statusDidChanged:CJMediaPlayerStatusAutoReplay];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(playerManager:statusDidChanged:)]) {
            [self.delegate playerManager:self statusDidChanged:status];
        }
    }
}

- (void)player:(CJMediaPlayer *)player timeDidChanged:(NSTimeInterval)time {
    if ([self.delegate respondsToSelector:@selector(playerManager:progressDidChange:)]) {
        if (ABS([self.mediaPlayer duration]) > DBL_EPSILON) {
            self.progress = ABS(time / [self.mediaPlayer duration]);
        }
        //MTLog(@"progress = %f", self.progress);
        [self.delegate playerManager:self progressDidChange:self.progress];
    }
}

- (void)player:(CJMediaPlayer *)player loadFailed:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(playerManager:loadFailed:)]) {
        [self.delegate playerManager:self loadFailed:error];
    }
    [self reset];
}


#pragma mark - 播放器缓存视频大小

// 单位：Byte
- (unsigned long long)fileSizeForCachePath {
    NSString *path = kVideoCachePath;
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager new]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}

/**
 * 清除缓存
 */
- (BOOL)cleanCache {
    NSString *path = kVideoCachePath;
    NSFileManager *fileManager = [NSFileManager new]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        BOOL isSuccess = [fileManager removeItemAtPath:path error:&error];
        return isSuccess;
    }

    return YES;

}

@end

//
//  CJPlayerManager.h
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CJMediaPlayerDefine.h"

@protocol CJPlayerManagerDelegate;
@class AVPlayerLayer, AVPlayer, CJVideoView;

@interface CJPlayerManager : NSObject

//@property (readonly, nonatomic) MTMediaDownloader *mediaDownloader;
@property (readonly, nonatomic) NSUInteger playCount;
@property(weak, readonly, nonatomic) id <CJPlayerManagerDelegate> delegate;
@property(strong, nonatomic, readonly) NSURL *url;
@property(readonly, nonatomic) CGFloat progress;
@property(readonly, nonatomic) NSTimeInterval duration;

// 最近一次调用过play方法的player id
@property (nonatomic, assign) unsigned long long lastActivePlayerID;

/**
 *  设置是否循环播放
 */
@property(assign, nonatomic) BOOL loopPlay;

/**
 *  获取单例
 *
 *  @return 单例
 */
+ (instancetype)sharePlayerManager;

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
               delegate:(id <CJPlayerManagerDelegate>)delegate;

/**
 *  预加载视频
 *
 *  @param preload 预加载的视频地址
 */
//- (void)preloadMediaWithURL:(NSURL *)preload;

/**
 *  当前播放标识的播放状态
 *
 *  @return 播放状态
 */
- (CJMediaPlayerStatus)status;

/**
 *  判断manager是否和相应的playIdentify link
 *
 *  @param playIdentify playIdentify
 *
 *  return  是否
 */
- (BOOL)isLinkedWithPlayIdentify:(NSString *)playIdentify;

/**
 *  返回videoView
 *
 *  @return videoView
 */
- (CJVideoView *)videoView;

- (void)willStartSeek;

- (void)endSeekOnValue:(float)value;

- (void)didEndSeek;

/**
 *  seek到当前百分比
 *
 *  @param percent 百分比
 */
- (void)seekToPercent:(float)percent completion:(void (^)(BOOL finished))completion;

/**
 *  调用播放
 */
- (void)play;

/**
 *  调用停止
 */
- (void)pause;

/**
 *  重置
 */
- (void)reset;

/**
 *  更新CJPlayerManager的delegate（并更新播放视图重置字典，保存上个相关的播放视图状态）
 */
- (void)updateDelegate:(id <CJPlayerManagerDelegate>)delegate;

/**
 *  播放视图重置字典，保存上个播放视图的视图状态
 */
@property(readonly, nonatomic) NSDictionary *restoreDic;

/**
 *  重置播放视图恢复字典，播放视图恢复过之后，重置这个字典。防止错误重置
 */
- (void)resetRestoreDic;

/**
 * 视频缓存的大小,单位：Byte
 */
- (unsigned long long)fileSizeForCachePath;

/**
 * 清除缓存
 */
- (BOOL)cleanCache;

@end

@protocol CJPlayerManagerDelegate <NSObject>

@optional
/**
 *  播放状态改变回调
 *
 *  @param playerManager 播放管理器
 *  @param status        播放状态
 */
- (void)playerManager:(CJPlayerManager *)playerManager statusDidChanged:(CJMediaPlayerStatus)status;

/**
 *  播放时间改变回调
 *
 *  @param playerManager    播放管理器
 *  @param progress         时间
 */
- (void)playerManager:(CJPlayerManager *)playerManager progressDidChange:(CGFloat)progress;

/**
 *  用于保存播放视图状态，用于恢复播放视图
 *
 *  @param playerManager 播放管理器
 *  @param restoreDic    播放视图状态数据(out)
 */
- (void)playerManager:(CJPlayerManager *)playerManager saveRestoreDic:(NSMutableDictionary *)restoreDic;

@required
/**
 *  播放状态出错
 */
- (void)playerManager:(CJPlayerManager *)playerManager loadFailed:(NSError *)error;

@end

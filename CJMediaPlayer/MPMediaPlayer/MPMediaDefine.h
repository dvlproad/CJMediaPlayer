//
//  MPMediaDefine.h
//  MeituMV
//
//  Created by Vito on 5/7/15.
//  Copyright (c) 2015 美图网. All rights reserved.
//

#ifndef MeituMV_MPMediaDefine_h
#define MeituMV_MPMediaDefine_h

#import "HexColor.h"
#import "PureLayout.h"

/**
 *  播放器状态
 */
typedef NS_ENUM(NSUInteger, MPMediaPlayerStatus){
    /**
     *  播放器未初始化
     */
    MPMediaPlayerStatusUnknow = 0,
    /**
     *  播放器加载中
     */
    MPMediaPlayerStatusLoading,
    /**
     *  播放器播放中
     */
    MPMediaPlayerStatusPlaying,
    /**
     *  播放器暂停中
     */
    MPMediaPlayerStatusPause,
    /**
     *  播放器播放结束
     */
    MPMediaPlayerStatusReachEnd,
    /**
     *  播放器播放结束并显示推荐视频
     */
    MPMediaPlayerStatusShowRecommend,
    /**
     *  播放器短视频自动播放
     */
    MPMediaPlayerStatusAutoReplay
};


//缓存目录
#define kVideoCachePath   [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/videoCache"]
#define kVideoTempPath    [NSTemporaryDirectory() stringByAppendingPathComponent:@"Incomplete"]

#endif

//
//  CJMediaPlayerDefine.h
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#ifndef CJMediaPlayerDefine_h
#define CJMediaPlayerDefine_h

/**
 *  播放器状态
 */
typedef NS_ENUM(NSUInteger, CJMediaPlayerStatus){
    /**
     *  播放器未初始化
     */
    CJMediaPlayerStatusUnknow = 0,
    /**
     *  播放器加载中
     */
    CJMediaPlayerStatusLoading,
    /**
     *  播放器播放中
     */
    CJMediaPlayerStatusPlaying,
    /**
     *  播放器暂停中
     */
    CJMediaPlayerStatusPause,
    /**
     *  播放器播放结束
     */
    CJMediaPlayerStatusReachEnd,
    /**
     *  播放器播放结束并显示推荐视频
     */
    CJMediaPlayerStatusShowRecommend,
    /**
     *  播放器短视频自动播放
     */
    CJMediaPlayerStatusAutoReplay
};


//缓存目录
#define kVideoCachePath   [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/videoCache"]
#define kVideoTempPath    [NSTemporaryDirectory() stringByAppendingPathComponent:@"Incomplete"]

#endif /* CJMediaPlayerDefine_h */

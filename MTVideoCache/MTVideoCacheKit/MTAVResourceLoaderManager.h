//
//  MTAVResourceLoader.h
//  TestTableView
//
//  Created by dvlproad on 16/3/9.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/**
 *  resource加载失败的回调定义
 *
 *  @param err 错误信息
 */
typedef void(^ResourceLoadFailedBlock)(NSError *err);


/**
 *  resource不存在的回调定义
 */
typedef void(^ResourceNotExistBlock)();



@interface MTAVResourceLoaderManager : NSObject<AVAssetResourceLoaderDelegate>

/** resource加载失败的回调  */
@property(nonatomic, copy)ResourceLoadFailedBlock  resourceLoadFailed;

/** resource不存在的回调  */
@property(nonatomic, copy)ResourceNotExistBlock  resourceNotExist;


/**
 *  切换视频时必须先调用该方法
 */
- (void)clean;

@end

//
//  MTAVResourceLoaderTask.h
//  TestTableView
//
//  Created by dvlproad on 16/3/10.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "MTAVResourceInfo.h"
#import "MTAVResourceRequest.h"



@interface MTAVResourceLoaderTask : NSObject


/** 回调 */
@property(nonatomic, copy)ResourceLoaderDataUpdateBlock resourceLoaderDataUpdate;
@property(nonatomic, copy)ResourceLoaderDataFinishBlock resourceLoaderDataFinish;
@property(nonatomic, copy)ResourceLoaderDataFinishBlock resourceLoaderDataAllFinish;       
@property(nonatomic, copy)ResourceLoaderDataFailedBlock resourceLoaderDataFailed;
@property(nonatomic, copy)ResourceLoaderDataNotExistBlock resourceLoaderDataNotExist;

/** 当前媒体缓存信息 */
@property(nonatomic, strong)MTAVResourceInfo *curResourceInfo;

/**
 *  初始化
 *
 *  @param url URL
 *
 *  @return loaderTask
 */
- (instancetype)initWithMediaUrl:(NSURL *)url;

/**
 *  请求数据
 *
 *  @param blockArr       未缓存的数据块数据
 *  @param loadingRequest LoadingRequest
 */
- (void)doLoadTaskWithDataBlockArr:(NSMutableArray *)blockArr
                    LoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest;



/**
 *  是否有缓存
 *
 *  @return
 */
- (BOOL)hasCached;



/**
 *  取消
 */
- (void)cancel;


/**
 *  清除
 */
- (void)clean;

@end

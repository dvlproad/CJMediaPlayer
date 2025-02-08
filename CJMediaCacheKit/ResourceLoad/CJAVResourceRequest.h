//
//  CJAVResourceRequest.h
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/15.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJAVResourceInfo.h"

typedef void(^ResourceLoaderDataUpdateBlock)();
typedef void(^ResourceLoaderDataFinishBlock)();
typedef void(^ResourceLoaderDataAllFinishBlock)();
typedef void(^ResourceLoaderDataFailedBlock)(NSError *err);
typedef void(^ResourceLoaderDataNotExistBlock)();


typedef NS_ENUM(NSUInteger, CJAVResourceRequestStatus) {
    CJAVResourceRequestStatus_initd,
    CJAVResourceRequestStatus_Loading,
    CJAVResourceRequestStatus_Cancel,
    CJAVResourceRequestStatus_Finish,
};



@interface CJAVResourceRequest : NSObject


@property(nonatomic, assign)CJAVResourceRequestStatus reqStatus;        //请求状态

@property(nonatomic, copy)ResourceLoaderDataUpdateBlock resourceLoaderDataUpdate;           //有数据更新
@property(nonatomic, copy)ResourceLoaderDataFinishBlock resourceLoaderDataFinish;           //某个请求下载完成

@property(nonatomic, copy)ResourceLoaderDataFailedBlock resourceLoaderDataFailed;           //下载失败
@property(nonatomic, copy)ResourceLoaderDataNotExistBlock resourceLoaderDataNotExist;       //资源不存在


@property (nonatomic, assign) int64_t  startPosition;             //本次网络下载的起始点
@property (nonatomic, assign) int64_t  curOffset;                 //当前文件偏移
@property (nonatomic, assign) int64_t  curSegmentOffset;          //当前段偏移
@property (nonatomic, assign) int64_t  requireLen;                //本次网络下载所需长度
@property (nonatomic, assign) int64_t  downLoadSize;              //用于记录此次已下载的数据


/**
 *  初始化
 *
 *  @param resourceInfo 资源信息
 *  @param offset       需下载的文件偏移
 *  @param len          需下载的数据长度
 *
 *  @return 请求
 */
- (instancetype)initWithResourceInfo:(CJAVResourceInfo *)resourceInfo
                              Offset:(int64_t)offset
                              Length:(int64_t)len;

/**
 *  开始请求
 */
- (void)start;

/**
 *  取消
 */
- (void)cancel;


/**
 *  清理
 */
- (void)clean;


@end

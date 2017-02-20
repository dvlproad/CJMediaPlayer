//
//  MTAVResourceInfo.h
//  TestTableView
//
//  Created by meitu on 16/3/9.
//  Copyright © 2016年 meitu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTAVResourceDataBlock.h"



typedef NS_ENUM(NSUInteger, MTAVResourceInfoStatus) {
    MTAVResourceInfoStatus_None,                //没有
    MTAVResourceInfoStatus_Partial,             //部分的
    MTAVResourceInfoStatus_Whole,               //完整的
};




@interface MTAVResourceInfo : NSObject

@property(nonatomic, copy)NSURL *url;                               //真实URL
@property(nonatomic, copy)NSString *contentType;                    //contentType
@property(nonatomic, assign, readonly)int64_t contentLength;      //长度
@property(nonatomic, strong)NSFileHandle *cacheFileHandle;          //文件handle



/** 下载状态 */
@property(nonatomic, assign)MTAVResourceInfoStatus status;

/** 片段集合:只记录未下载的部分 */
@property(nonatomic, strong)NSMutableSet *segmentSet;




/**
 *  设置contentLength
 *
 *  @param contentLen 长度值
 */
- (void)configContentLength:(int64_t)contentLen;


#pragma mark - 缓存

/**
 *  从缓存描述文件中实例化MTAVResourceInfo
 *
 *  @param descPath 缓存描述文件的路径
 *
 *  @return MTAVResourceInfo实例对象
 */
+ (MTAVResourceInfo *)resourceInfoFromCacheWithDescPath:(NSString *)descPath;



/**
 *  缓存到文件中
 */
- (void)cache;


#pragma mark - 文件片段缓存相关

/**
 *  判断片段区域是否已缓存
 *
 *  @param startSegment 起始片段的索引
 *  @param endSegment   结束片段的索引
 *
 *  @return 是否已缓存
 */
- (BOOL)isCachedWithStartSegment:(int64_t)startSegment EndSegment:(int64_t)endSegment;



/**
 *  返回文件空洞数组
 *
 *  @param startSegment 起始片段的索引值
 *
 *  @return 文件空洞的dataBlock数组
 */
- (NSMutableArray *)calcRequestBlockWithStartSegment:(int64_t)startSegment;




/**
 *  对未缓存的segment索引进行排序
 *
 *  @return 已排序的segment索引数组
 */
- (NSArray *)sortedSegmentArr;


#pragma mark - 文件片段计算相关

/**
 *  返回片段长度
 *
 *  @return segment长度
 */
+ (int64_t)segmentLength;


/**
 *  返回seek阈值
 *
 *  @return seek阈值
 */
+ (int64_t)seekInterval;


/**
 *  判断offset位于第几片段
 *
 *  @param offset 偏移值
 *
 *  @return 片段索引值
 */
+ (int64_t)segmentWithOffset:(int64_t)offset;


/**
 *  返回offset + length 位于第几片段(该段数据的最后一个字节)
 *
 *  @param offset 偏移值
 *  @param length 长度
 *
 *  @return 片段索引值
 */
+ (int64_t)segmentWithOffset:(int64_t)offset Length:(int64_t)length;




@end

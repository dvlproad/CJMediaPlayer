//
//  MTAVRourceCacheManager.h
//  TestTableView
//
//  Created by dvlproad on 16/3/9.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTAVResourceCache : NSObject


#pragma mark - cache


/**
 *  媒体缓存目录
 *
 *  @return 媒体缓存目录
 */
+ (NSString *)videoCacheDictory;



#pragma mark - 媒体文件和媒体缓存描述文件

//媒体文件缓存文件名和路径(真实URL)
+ (NSString *)cachedFileNameByURL:(NSURL *)url;
+ (NSString *)cachedPathByURL:(NSURL *)url;

//媒体文件缓存描述文件的文件名和路径(真实URL)
+ (NSString *)cachedDescFileNameByURL:(NSURL *)url;
+ (NSString *)cachedDescPathByURL:(NSURL *)url;



#pragma mark - File Handle


//获取某个文件的完整路径
+ (NSString*)getPathByVideoFileName:(NSString *)fileName;

//判断缓存文件是否存在(真实URL)
+ (BOOL)cacheFileExistsAtURL:(NSURL *)url;

//判断文件是否存在(filePath:完整路径)
+ (BOOL)fileExistsAtPath:(NSString*)filePath;

//判断文件是否存在(fileName:文件名)
+ (BOOL)fileExistsWithFileName:(NSString*)fileName;

//删除某个video文件(filePath:完整路径)
+ (BOOL)removeVideoFileAtPath:(NSString*)filePath;

//删除某个video文件(fileName:文件名)
+ (BOOL)removeVideoWithFileName:(NSString*)fileName;

//move某个video文件(fileName:文件名)
+ (BOOL)moveVideoFilePath:(NSString*)filePath;

//创建缓存文件
+ (void)createCacheFileAtPath:(NSString *)filePath;


//清空所有缓存
+ (BOOL)cleanCache;



@end

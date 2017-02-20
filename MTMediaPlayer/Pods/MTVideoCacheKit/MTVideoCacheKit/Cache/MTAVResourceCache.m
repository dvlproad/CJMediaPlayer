//
//  MTAVRourceCacheManager.m
//  TestTableView
//
//  Created by meitu on 16/3/9.
//  Copyright © 2016年 meitu. All rights reserved.
//

#import "MTAVResourceCache.h"
#import "MTAVUtil.h"

static NSString *videoCacheFolder               = @"video";
static NSString *videoCacheDescSuffix           = @"_desc";

@implementation MTAVResourceCache


#pragma mark - cache


+ (NSString *)videoCacheDictory {
    
//    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    NSString *cachePath = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];

    //调试时候,缓存放在document目录，方便查看
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    
    
    NSString *videoPath = [cachePath stringByAppendingPathComponent:videoCacheFolder];
    
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:videoPath isDirectory:&isDir];
    
    if (!(isExist && isDir)) {
        
        //创建缓存目录
        [[NSFileManager defaultManager] createDirectoryAtPath:videoPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    return videoPath;
    
}




+ (NSString *)cachedFileNameByURL:(NSURL *)url {
    
    NSString *fileName = [MTAVUtil md5Sum:url.absoluteString];  //对url MD5
    fileName = [fileName stringByAppendingString:@".mp4"];
    return fileName;
}

+ (NSString *)cachedPathByURL:(NSURL *)url {
    NSString *fileName = [self cachedFileNameByURL:url];
    NSString *path = [self getPathByVideoFileName:fileName];
    return path;
}




+ (NSString *)cachedDescFileNameByURL:(NSURL *)url {
    
    NSString *fileName = [MTAVUtil md5Sum:url.absoluteString];  //对url MD5
    fileName = [fileName stringByAppendingString:videoCacheDescSuffix];
    return fileName;
}

+ (NSString *)cachedDescPathByURL:(NSURL *)url {
    NSString *fileName = [self cachedDescFileNameByURL:url];
    NSString *path = [self getPathByVideoFileName:fileName];
    return path;
}





#pragma mark - File Handle


+ (int64_t)fileSizeFromPath:(NSString *)filePath {
    //新建一个数组，包含想要了解的属性
    NSArray *attributes = [NSArray arrayWithObjects:NSURLFileSizeKey,nil];
    
    //获取文件属性
    NSDictionary *attributesDictionary = [[NSURL fileURLWithPath:filePath] resourceValuesForKeys:attributes error:nil];
    
    //获取文件大小
    NSNumber *fileSizeInBytes = [attributesDictionary objectForKey:NSURLFileSizeKey];
    
    
    if (fileSizeInBytes) {
        return [fileSizeInBytes longLongValue];
    } else {
        return -1;
    }
}


//获取某个文件的完整路径
+ (NSString*)getPathByVideoFileName:(NSString *)fileName {
    return [[self videoCacheDictory] stringByAppendingPathComponent:fileName];
}

+ (BOOL)cacheFileExistsAtURL:(NSURL *)url {

    //判断URL对应的媒体文件缓存是否存在， 如果不存在，返回NO
    NSString *mediaCachePath = [self cachedPathByURL:url];
    return [self fileExistsAtPath:mediaCachePath];
    
}

//判断文件是否存在(完整路径)
+ (BOOL)fileExistsAtPath:(NSString*)filePath {
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (BOOL)fileExistsWithFileName:(NSString*)fileName {
    NSString *filePath = [self getPathByVideoFileName:fileName];
    return [self fileExistsAtPath:filePath];
}

//删除某个video文件
+ (BOOL)removeVideoFileAtPath:(NSString*)filePath {
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

//删除某个video文件
+ (BOOL)removeVideoWithFileName:(NSString*)fileName {
    NSString *filePath = [self getPathByVideoFileName:fileName];
    return [[NSFileManager defaultManager] removeItemAtPath:filePath
                                                      error:nil];
}

//move某个video文件
+ (BOOL)moveVideoFilePath:(NSString*)filePath {
    NSString *cachePath = [self videoCacheDictory];
    return [[NSFileManager defaultManager] moveItemAtPath:filePath
                                                   toPath:cachePath
                                                    error:nil];
}



+ (void)createCacheFileAtPath:(NSString *)filePath {
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {
        
        [[NSFileManager defaultManager] createFileAtPath:filePath
                                                contents:nil
                                              attributes:nil];
    }
}



#pragma mark - Clean

+ (BOOL)cleanCache {
    NSString *videoCachePath = [self videoCacheDictory];
    
    //判断缓存目录是否存在
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:videoCachePath isDirectory:&isDir];
    
    
    //缓存目录存在，则删除
    if (isExist && isDir) {
        
        return [[NSFileManager defaultManager] removeItemAtPath:videoCachePath error:nil];
    } else {
        return YES;
    }
}




@end

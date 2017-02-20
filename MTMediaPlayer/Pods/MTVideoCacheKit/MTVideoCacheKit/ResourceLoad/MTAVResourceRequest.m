//
//  MTAVResourceConnection.m
//  TestTableView
//
//  Created by meitu on 16/3/15.
//  Copyright © 2016年 meitu. All rights reserved.
//

#import "MTAVResourceRequest.h"

#include <stdlib.h>
#include <malloc/malloc.h>

#import "MTAVResourceCache.h"


@interface MTAVResourceRequest ()<NSURLSessionDataDelegate>

@property(nonatomic, strong)NSURLSession *session;              //连接
@property(nonatomic, strong)NSURLSessionDataTask *dataTask;



@property(nonatomic, assign)NSInteger reconnectTimes;           //重连次数
@property(nonatomic, weak)MTAVResourceInfo *curResourceInfo;    //当前资源信息

@property(nonatomic, strong)NSMutableData *cacheData;           //缓存请求返回的数据,减少文件IO操作
@property(nonatomic, assign)NSInteger descChangedTimes;        //视频描述变化次数,用于减少文件IO操作


@end

@implementation MTAVResourceRequest


- (instancetype)initWithResourceInfo:(MTAVResourceInfo *)resourceInfo
                              Offset:(int64_t)offset
                              Length:(int64_t)len {
    self = [super init];
    if (self) {
        
        //初始化
        self.curResourceInfo    = resourceInfo;

        self.startPosition      = offset;
        self.curOffset          = offset;
        self.curSegmentOffset   = offset;
        
        self.requireLen         = len;
        self.downLoadSize       = 0;
        
        self.reqStatus          = MTAVResourceRequestStatus_initd;   //初始化状态
        
        self.reconnectTimes     = 0;
        
        self.descChangedTimes   = 0;
        
        
        self.cacheData          = [[NSMutableData alloc] initWithCapacity:0];
        
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSLog(@"config = %@", config);
        
        
        self.session =
        [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                      delegate:self
                                 delegateQueue:[NSOperationQueue mainQueue]];

        [self sendRequestWithOffset:offset Length:len];
    }
    return self;
}




- (void)start {
    self.reqStatus = MTAVResourceRequestStatus_Loading;    //下载状态
    [self.dataTask resume];

}

- (void)cancel {
    
    self.reqStatus = MTAVResourceRequestStatus_Cancel;      //取消状态
    
    self.resourceLoaderDataUpdate = nil;
    self.resourceLoaderDataFinish = nil;
    self.resourceLoaderDataFailed = nil;
    self.resourceLoaderDataNotExist = nil;
    
    [self.dataTask cancel];

}

- (void)clean {
    
    [self cancel];
    self.dataTask = nil;
    self.session = nil;
}



#pragma mark -  NSURLConnection Delegate Methods



- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary *headerDic = (NSDictionary *)[httpResponse allHeaderFields];
    
    NSLog(@"headerDic = %@", headerDic);
    NSString *contentType   = [headerDic valueForKey:@"Content-Type"];
    NSNumber *contentLength = [headerDic valueForKey:@"Content-Length"];
    
    //如果文件类型为text/html, 可以认为该视频文件不存在，即服务器返回 404
    if (httpResponse.statusCode >= 400) { //[contentType isEqualToString:@"text/html"]
        
        self.reqStatus = MTAVResourceRequestStatus_Finish;      //结束状态
        
        //通知loaderManager
        if (self.resourceLoaderDataNotExist) {
            self.resourceLoaderDataNotExist();
        }
        
        //取消
        completionHandler(NSURLSessionResponseCancel);
        
    } else {
        
        //保存contentType和contentLength
        NSString *curType = self.curResourceInfo.contentType;
        BOOL isEmptyTpye = !curType || (curType.length == 0);
        
        //判断是否是第一次下载该文件
        if (self.startPosition == 0 && isEmptyTpye) {
            
            
            //初始化文件数据
            int64_t len = [contentLength longLongValue];
            char *zeroPoint = malloc((size_t)len);
            memset(zeroPoint, 0, (size_t)len);
            
            //写入缓存文件
            NSMutableData *data = [[NSMutableData alloc] initWithBytes:zeroPoint length:(NSUInteger)len];
            
            //[self.curResourceInfo.cacheFileHandle seekToFileOffset:0];
            [self.curResourceInfo.cacheFileHandle writeData:data];
            [self.curResourceInfo.cacheFileHandle synchronizeFile];
            
            self.curResourceInfo.contentType = contentType;
            [self.curResourceInfo configContentLength:[contentLength longLongValue]];
            [self.curResourceInfo cache];
        }
        

        //允许处理服务器的响应，才会继续接收服务器返回的数据
        completionHandler(NSURLSessionResponseAllow);
    }

}


- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {

    //1级缓存，减少文件IO操作，降低CPU
    [self.cacheData appendData:data];
    if ([self.cacheData length] < [MTAVResourceInfo segmentLength]) {
        return;
    }


    //保存缓存数据
    [self saveCacheData];
    
    //清空缓存
    [self.cacheData setData:[NSData data]];
    
    //判断下载的数据是否大于一个片段，如果大于则更新resourceInfo
    BOOL flag = NO;
    int64_t segLen = [MTAVResourceInfo segmentLength];
    while (self.downLoadSize >= segLen) {
        
        flag = YES;
        int64_t segment = self.curSegmentOffset / segLen;
        [self.curResourceInfo.segmentSet removeObject:@(segment)];
        
        self.curSegmentOffset   += segLen;
        self.downLoadSize       -= segLen;
    }
    
    
    //打印segmentSet的当前元素个数
    NSLog(@"____segmentSet.curCount = %tu", [self.curResourceInfo.segmentSet count]);
    
    
    //通知loaderManager
    if ( flag && self.resourceLoaderDataUpdate) {
        self.resourceLoaderDataUpdate();
    }
    
    self.curResourceInfo.status = MTAVResourceInfoStatus_Partial;
    self.descChangedTimes++;
    
    
    if (self.descChangedTimes % 5 == 0) {
        [self.curResourceInfo cache];   //缓存到文件中
    }
    
}






- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {

    if (error) {
        
        [self dataLoadDidFailWithError:error];
        
    } else {
        [self dataLoadDidFinish];
    }

}




- (void)dataLoadDidFinish {
    
    NSLog(@"请求完成");
    if ([self.cacheData length] > 0) {
        
        //保存缓存数据
        [self saveCacheData];
    }

    NSLog(@"____segmentSet.curCount = %tu", self.curResourceInfo.segmentSet.count);
    
    self.reqStatus = MTAVResourceRequestStatus_Finish;      //请求结束
    
    ////判断是否为最后一个片段下载完成
    if (self.curOffset >= self.curResourceInfo.contentLength - 1) {
        
        int64_t segment = self.curOffset / [MTAVResourceInfo segmentLength];
        [self.curResourceInfo.segmentSet removeObject:@(segment)];
    }
    
    
    //判断所有片段是否下载完成
    if ([self.curResourceInfo.segmentSet count] == 0) {
        self.curResourceInfo.status = MTAVResourceInfoStatus_Whole;
        
    }
    
    //缓存resourceInfo
    [self.curResourceInfo cache];

    
    if (self.resourceLoaderDataFinish) {
        self.resourceLoaderDataFinish();
    }
    
}


- (void)dataLoadDidFailWithError:(NSError *)error {
    
    if (error.code == -1001) {
        
        //网络超时, 判断重连次数是否小于3(最多重连3次),  是的话1秒后重连, 否则通知loaderManager
        if (self.reconnectTimes < 3) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self continueLoading];
            });
            
            return;
        }
    }
    
    //其他网络情况, 通知loaderManager
    if (self.resourceLoaderDataFailed) {
        self.resourceLoaderDataFailed(error);
    }
}




#pragma mark - Private


- (void)saveCacheData {

    
    NSLog(@"response________: curOffset = %lld, len = %tu", self.curOffset, self.cacheData.length);


    [self.curResourceInfo.cacheFileHandle seekToFileOffset:self.curOffset];
    [self.curResourceInfo.cacheFileHandle writeData:self.cacheData];
    [self.curResourceInfo.cacheFileHandle synchronizeFile];
    
    //更新当前offset和下载数目
    self.curOffset      += self.cacheData.length;
    self.downLoadSize   += self.cacheData.length;

}


- (void)continueLoading
{
    //重连次数+1, 并继续上次下载
    self.reconnectTimes += 1;
    
    if (self.requireLen > 0) {
        [self sendRequestWithOffset:self.curOffset Length:self.requireLen - (self.curOffset - self.startPosition)];
    } else {
        [self sendRequestWithOffset:self.curOffset Length:-1];
    }
    

    [self start];
}


- (void)sendRequestWithOffset:(int64_t)offset Length:(int64_t)len
{

    //创建下载请求，超时值15s
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:self.curResourceInfo.url
                            cachePolicy:NSURLRequestReloadIgnoringCacheData
                        timeoutInterval:15.0];
    
    
    if (offset > 0 && len > 0) {
        NSString *range = [NSString stringWithFormat:@"bytes=%lld-%lld", offset, offset + len - 1];
        [request addValue:range forHTTPHeaderField:@"Range"];
        NSLog(@"sendRequest______________: offset = %lld, len = %lld, range = %@", offset, len, range);
    } else {
        
        NSLog(@"sendRequest______________: offset = %lld, len = %lld, range = nil", offset, len);
    }
    
    self.dataTask = [self.session dataTaskWithRequest:request];

}


- (NSString *)description
{
    
    NSString *str =
    [NSString stringWithFormat:@"\nstartPosition = %lld, curOffset = %lld, curSegmentOffset = %lld, requireLen = %lld, downLoadSize = %lld",
     self.startPosition, self.curOffset, self.curSegmentOffset, self.requireLen, self.downLoadSize];

    return str;
    
}

@end

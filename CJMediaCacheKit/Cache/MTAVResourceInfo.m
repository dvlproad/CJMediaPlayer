//
//  MTAVResourceInfo.m
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/9.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "MTAVResourceInfo.h"
#import "CJAVUtil.h"
#import "CJAVResourceCache.h"


const int64_t  kSegmentLength = 10 * 1024;    //10K
const int64_t  kSeekInterval = 300 * 1024;    //200K以下没有声音，200K~300K没测



#define KeyUrl                      @"key.url"
#define KeyContentType              @"key.contentType"
#define KeyContentLength            @"key.contentLength"
#define KeySegmentSet               @"key.segmentSet"
#define KeyStatus                   @"key.status"


@interface MTAVResourceInfo ()

@property(nonatomic, assign)int64_t contentLength;

@end


@implementation MTAVResourceInfo


- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithUrl:(NSURL *)mediaUrl {
    self = [super init];
    if (self) {
        
        [self commonInit];
        self.url = [mediaUrl copy];
    }
    return self;
}


- (void)commonInit {
    self.url            = nil;
    self.contentType    = nil;
    self.contentLength  = 0;
    self.status         = MTAVResourceInfoStatus_None;
    
    //初始化
    self.segmentSet = [NSMutableSet set];

}


#pragma mark - NSCopyding

- (id)copyWithZone:(NSZone *)zone {
    
    
    MTAVResourceInfo *copy = [[[self class] allocWithZone:zone] init];
    
    copy.url            = [self.url copy];
    copy.contentType    = [self.contentType copy];
    copy.contentLength  = self.contentLength;
    copy.status         = self.status;
    copy.segmentSet     = [NSMutableSet set];


    for (NSNumber *segment in self.segmentSet) {
        [copy.segmentSet addObject:[segment copy]];
    }
    
    return copy;
}



#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_url forKey:KeyUrl];
    [aCoder encodeObject:_contentType forKey:KeyContentType];
    [aCoder encodeInt64:_contentLength forKey:KeyContentLength];
    [aCoder encodeObject:_segmentSet forKey:KeySegmentSet];
    [aCoder encodeInteger:_status forKey:KeyStatus];
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        _url            = [aDecoder decodeObjectForKey:KeyUrl];
        _contentType    = [aDecoder decodeObjectForKey:KeyContentType];
        _contentLength  = [aDecoder decodeInt64ForKey:KeyContentLength];
        _segmentSet     = [aDecoder decodeObjectForKey:KeySegmentSet];
        _status         = [aDecoder decodeIntegerForKey:KeyStatus];

    }
    
    return self;
}




- (void)configContentLength:(int64_t)contentLen {
    self.contentLength = contentLen;
    int64_t segLen = [MTAVResourceInfo segmentLength];
    
    int64_t segCount = contentLen / segLen;
    if (contentLen % segLen != 0) {
        segCount = contentLen / segLen + 1;
    }
    
    
    //全部添加到set中
    for (int64_t i = 0; i < segCount; ++i) {
        
        if (self.segmentSet) {
            [self.segmentSet addObject:@(i)];
        }
    }
    
}



#pragma mark - 缓存

+ (MTAVResourceInfo *)resourceInfoFromCacheWithDescPath:(NSString *)descPath {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:descPath];
}


- (void)cache {
    //首先判断是否存在缓存文件，如果存在，则先删除，然后再缓存
    NSString *path = [CJAVResourceCache cachedDescPathByURL:self.url];
    
//    if ([CJAVResourceCache fileExistsAtPath:path]) {
//        [CJAVResourceCache removeVideoFileAtPath:path];
//    }

    //缓存到本地
    [NSKeyedArchiver archiveRootObject:self toFile:path];
}


#pragma mark - 文件片段缓存相关


//判断片段区域是否已缓存
- (BOOL)isCachedWithStartSegment:(int64_t)startSegment EndSegment:(int64_t)endSegment {
    BOOL iscached = YES;
    
    for (int64_t i = startSegment; i <= endSegment; ++i) {
        if ([self.segmentSet containsObject:@(i)]) {
            iscached = NO;
            break;
        }
    }
    return iscached;
    
}







- (NSArray *)sortedSegmentArr {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSNumber *number in self.segmentSet) {
        [arr addObject:number];
    }
    return [arr sortedArrayUsingSelector:@selector(compare:)];
}



- (NSMutableArray *)calcRequestBlockWithStartSegment:(int64_t)startSegment {
    
    NSMutableArray *blockArr = [NSMutableArray array];
    
    //找出最大segment
    NSArray *sortedArr = [self sortedSegmentArr];
    int64_t maxSegment = [[sortedArr lastObject] longLongValue];
    
    

    BOOL findHead = YES;
    CJAVResourceDataBlock *block = nil;
    for (int64_t i = startSegment; i <= maxSegment; ++i) {
        
        if (findHead) {
            
            //先找block的startSegment
            if ([self.segmentSet containsObject:@(i)]) {
                
                block = [[CJAVResourceDataBlock alloc] initWithStartSegment:i];
                block.endSegment = i;
                findHead = NO;
                
                if (i == maxSegment) {
                    [blockArr addObject:block];
                }
            }
            
        } else {
            
            if ([self.segmentSet containsObject:@(i)]) {
                block.endSegment = i;
                
                if (i == maxSegment) {
                    [blockArr addObject:block];
                }
            } else {
                
                [blockArr addObject:block];
                block = nil;
                findHead = YES;
            }
        }
    }

    return blockArr;
}










#pragma mark - 文件片段计算相关



+ (int64_t)segmentLength {
    return kSegmentLength;
}


+ (int64_t)seekInterval {
    return kSeekInterval;
}


//位于第几片段
+ (int64_t)segmentWithOffset:(int64_t)offset {
    return offset / kSegmentLength;
}


//位于第几片段(该段数据的最后一个字节)
+ (int64_t)segmentWithOffset:(int64_t)offset Length:(int64_t)length {
    return (offset + length - 1) / kSegmentLength;
}






@end

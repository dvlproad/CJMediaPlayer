//
//  CJAVResourceDataBlock.m
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/14.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJAVResourceDataBlock.h"
#import "CJAVResourceInfo.h"

@implementation CJAVResourceDataBlock

- (instancetype)initWithStartSegment:(int64_t)startSegment {
    self = [super init];
    if (self) {
        
        _startSegment = startSegment;
    }
    return self;
}



- (int64_t)offset {
    return self.startSegment * [CJAVResourceInfo segmentLength];
}

- (int64_t)len {
    return ( self.endSegment - self.startSegment + 1 ) * [CJAVResourceInfo segmentLength];
}

@end

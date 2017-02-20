//
//  MTAVResourceDataBlock.m
//  TestTableView
//
//  Created by meitu on 16/3/14.
//  Copyright © 2016年 meitu. All rights reserved.
//

#import "MTAVResourceDataBlock.h"
#import "MTAVResourceInfo.h"

@implementation MTAVResourceDataBlock

- (instancetype)initWithStartSegment:(int64_t)startSegment {
    self = [super init];
    if (self) {
        
        _startSegment = startSegment;
    }
    return self;
}



- (int64_t)offset {
    return self.startSegment * [MTAVResourceInfo segmentLength];
}

- (int64_t)len {
    return ( self.endSegment - self.startSegment + 1 ) * [MTAVResourceInfo segmentLength];
}

@end

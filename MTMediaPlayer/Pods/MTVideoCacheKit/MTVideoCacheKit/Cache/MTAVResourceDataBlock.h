//
//  MTAVResourceDataBlock.h
//  TestTableView
//
//  Created by meitu on 16/3/14.
//  Copyright © 2016年 meitu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTAVResourceDataBlock : NSObject

@property(nonatomic, assign)int64_t startSegment;     //起始片段的索引
@property(nonatomic, assign)int64_t endSegment;       //结束片段的索引

@property(nonatomic, assign, readonly)int64_t offset;   //偏移
@property(nonatomic, assign, readonly)int64_t len;      //长度


/**
 *  初始化
 *
 *  @param startSegment 起始片段的索引
 *
 *  @return dataBlock(数据块)
 */
- (instancetype)initWithStartSegment:(int64_t)startSegment;




@end

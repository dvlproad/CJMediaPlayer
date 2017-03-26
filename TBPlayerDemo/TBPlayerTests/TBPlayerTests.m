//
//  TBPlayerTests.m
//  TBPlayerTests
//
//  Created by dvlproad on 16/3/17.
//  Copyright © 2016年 SF. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MTAVCacheKit.h"

@interface TBPlayerTests : XCTestCase

@end

@implementation TBPlayerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    
//    MTAVResourceInfo *info = [[MTAVResourceInfo alloc] init];
//    info.segmentSet = [[NSMutableSet alloc] initWithObjects:@(1), @(2), @(4), @(5),  @(7), @(11), @(12), @(13), @(14), @(15),  nil];
//
//
//    NSMutableArray *blockArr = [info calcRequestBlockWithStartSegment:2];
//    for (MTAVResourceDataBlock *block in blockArr) {
//        NSLog(@"block.start = %ld, end = %ld", block.startSegment, block.endSegment);
//    }
//    
//    
//    Byte myByte[100] = {0};
//    NSMutableData *data = [[NSMutableData alloc] initWithBytes:myByte length:100];
//    NSString *testPath = [MTAVResourceCache cachedPathByURL:[NSURL URLWithString:@"http://www.baidu.com"]];
//    NSLog(@"path = %@", testPath);
//    [data writeToFile:testPath atomically:YES];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

//
//  VideoModel.h
//  TBPlayer
//
//  Created by dvlproad on 16/3/23.
//  Copyright © 2016年 SF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject

@property(nonatomic, copy)NSString *videoUrl;

- (instancetype)initWithVideoUrl:(NSString *)url;

@end

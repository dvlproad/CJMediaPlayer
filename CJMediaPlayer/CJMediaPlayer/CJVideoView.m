//
//  MPMediaView.m
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJVideoView.h"

@interface CJVideoView ()

@end

@implementation CJVideoView

+ (Class) layerClass
{
    return [AVPlayerLayer class];
}

- (AVPlayer *) player
{
    return [(AVPlayerLayer *) [self layer] player];
}

- (AVPlayerLayer *) playerLayer
{
    return (AVPlayerLayer *) self.layer;
}

- (void) setPlayer:(AVPlayer *)player
{
    [(AVPlayerLayer *) [self layer] setPlayer:player];
}

@end

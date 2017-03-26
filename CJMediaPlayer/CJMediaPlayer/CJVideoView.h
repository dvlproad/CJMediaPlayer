//
//  MPMediaView.h
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CJVideoView : UIView

- (AVPlayerLayer *)playerLayer;

/**
 *  为 MPMediaView 绑定一个 player，MPMediaView 显示 player 下载的视频
 */
- (void)setPlayer:(AVPlayer *)player;

@end

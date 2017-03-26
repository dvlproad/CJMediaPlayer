//
//  VideoModel.h
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CJFileModel.h"

@interface VideoModel : NSObject {
    
}
@property (nonatomic, strong) CJFileModel *videoFile;   /**< 视频信息 */
@property (nonatomic, strong) CJFileModel *firstFrameImageFile; /**< 第一帧(预览图)信息 */

@property (nonatomic, strong, readonly) UIImage *image;

- (id)initWithVideoUrl:(NSString *)URL;


@end

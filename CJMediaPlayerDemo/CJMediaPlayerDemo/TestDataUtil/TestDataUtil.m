//
//  TestDataUtil.m
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TestDataUtil.h"

@implementation TestDataUtil
//地址来源：http://tieba.baidu.com/f?kw=%CA%D3%C6%B5&fr=ala0&tpl=5

+ (NSMutableArray<VideoModel *> *)getTestVideoModels {
    NSMutableArray *videoModels = [[NSMutableArray alloc] init];
    
    {
        NSString *Url = @"https://www.tikwm.com/video/media/wmplay/7465611957203160340.mp4";
        CJFileModel *videoFile = [[CJFileModel alloc] initWithNetworkAbsoluteUrl:Url];
        NSString *imageLocalAbsolutePath = [[NSBundle mainBundle] pathForResource:@"好听到怀孕的一人饮酒醉" ofType:@"jpg"];
        CJFileModel *firstFrameImageFile = [[CJFileModel alloc] initWithLocalAbsolutePath:imageLocalAbsolutePath sourceType:CJFileSourceTypeLocalBundle];
        
        VideoModel *videoModel = [[VideoModel alloc] init];
        videoModel.videoFile = videoFile;
        videoModel.firstFrameImageFile = firstFrameImageFile;
        [videoModels addObject:videoModel];
    }
    
    {
        CJFileModel *videoFile = [[CJFileModel alloc] initWithNetworkAbsoluteUrl:@"https://www.tikwm.com/video/media/play/7465611957203160340.mp4"];
        NSString *imageLocalAbsolutePath = [[NSBundle mainBundle] pathForResource:@"月光宝盒" ofType:@"jpg"];
        CJFileModel *firstFrameImageFile = [[CJFileModel alloc] initWithLocalAbsolutePath:imageLocalAbsolutePath sourceType:CJFileSourceTypeLocalBundle];
        
        VideoModel *videoModel = [[VideoModel alloc] init];
        videoModel.videoFile = videoFile;
        videoModel.firstFrameImageFile = firstFrameImageFile;
        [videoModels addObject:videoModel];
    }
    
    {
        CJFileModel *videoFile = [[CJFileModel alloc] initWithNetworkAbsoluteUrl:@"https://www.tikwm.com/video/media/hdplay/7465611957203160340.mp4"];
        NSString *imageLocalAbsolutePath = [[NSBundle mainBundle] pathForResource:@"老4机带你走" ofType:@"jpg"];
        CJFileModel *firstFrameImageFile = [[CJFileModel alloc] initWithLocalAbsolutePath:imageLocalAbsolutePath sourceType:CJFileSourceTypeLocalBundle];
        
        VideoModel *videoModel = [[VideoModel alloc] init];
        videoModel.videoFile = videoFile;
        videoModel.firstFrameImageFile = firstFrameImageFile;
        [videoModels addObject:videoModel];
    }
    
    {
        CJFileModel *videoFile = [[CJFileModel alloc] initWithNetworkAbsoluteUrl:@"http://tb-video.bdstatic.com/tieba-smallvideo/186_8421118854a759b008f88f165f6e4a77.mp4"];
        NSString *imageLocalAbsolutePath = [[NSBundle mainBundle] pathForResource:@"新闻" ofType:@"jpg"];
        CJFileModel *firstFrameImageFile = [[CJFileModel alloc] initWithLocalAbsolutePath:imageLocalAbsolutePath sourceType:CJFileSourceTypeLocalBundle];
        
        VideoModel *videoModel = [[VideoModel alloc] init];
        videoModel.videoFile = videoFile;
        videoModel.firstFrameImageFile = firstFrameImageFile;
        [videoModels addObject:videoModel];
    }
    
    {
        CJFileModel *videoFile = [[CJFileModel alloc] initWithNetworkAbsoluteUrl:@"http://tb-video.bdstatic.com/tieba-smallvideo/31_d60d53471eeb3bac193ee02df8446d2b.mp4"];
        NSString *imageLocalAbsolutePath = [[NSBundle mainBundle] pathForResource:@"香肠舞" ofType:@"jpg"];
        CJFileModel *firstFrameImageFile = [[CJFileModel alloc] initWithLocalAbsolutePath:imageLocalAbsolutePath sourceType:CJFileSourceTypeLocalBundle];
        
        VideoModel *videoModel = [[VideoModel alloc] init];
        videoModel.videoFile = videoFile;
        videoModel.firstFrameImageFile = firstFrameImageFile;
        [videoModels addObject:videoModel];
    }
    
    {
        CJFileModel *videoFile = [[CJFileModel alloc] initWithNetworkAbsoluteUrl:@"http://tb-video.bdstatic.com/tieba-smallvideo/1252235_378b225346db5f10cf8b492fc516fef9.mp4"];
        NSString *imageLocalAbsolutePath = [[NSBundle mainBundle] pathForResource:@"打鼓妹" ofType:@"jpg"];
        CJFileModel *firstFrameImageFile = [[CJFileModel alloc] initWithLocalAbsolutePath:imageLocalAbsolutePath sourceType:CJFileSourceTypeLocalBundle];
        
        VideoModel *videoModel = [[VideoModel alloc] init];
        videoModel.videoFile = videoFile;
        videoModel.firstFrameImageFile = firstFrameImageFile;
        [videoModels addObject:videoModel];
    }
    
    {
        CJFileModel *videoFile = [[CJFileModel alloc] initWithNetworkAbsoluteUrl:@"http://tb-video.bdstatic.com/tieba-smallvideo/1252235_759edb019cdad3725eb4798e60b48def.mp4"];
        NSString *imageLocalAbsolutePath = [[NSBundle mainBundle] pathForResource:@"你长的好漂亮，好想亲你一口" ofType:@"jpg"];
        CJFileModel *firstFrameImageFile = [[CJFileModel alloc] initWithLocalAbsolutePath:imageLocalAbsolutePath sourceType:CJFileSourceTypeLocalBundle];
        
        VideoModel *videoModel = [[VideoModel alloc] init];
        videoModel.videoFile = videoFile;
        videoModel.firstFrameImageFile = firstFrameImageFile;
        [videoModels addObject:videoModel];
    }
    
    
    
    return videoModels;
}

@end

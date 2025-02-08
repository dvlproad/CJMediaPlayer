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
        NSString *Url = @"https://v11-default.365yg.com/1c7883e48a1eafa0718e81ba60366c6e/67a78ff5/video/tos/cn/tos-cn-ve-15/ok492pE6eFAoNnDnAv3GD4gIDfA7FAQxqBAnwE/?a=2011&ch=0&cr=0&dr=0&cd=0%7C0%7C0%7C0&cv=1&br=2371&bt=2371&cs=0&ds=3&ft=aT_7TQQqUYqfJEZPo0OW_QYaUqiX5DH4oVJE6BUgJvPD-Ipz&mime_type=video_mp4&qs=0&rc=Ozw2OTQ6Z2g8ODxoPDVnZkBpM2t0OHU5cmtqeDMzNGkzM0A2YGM0Li82XjExYy5jMzQzYSNwaXMtMmRrb2dgLS1kLTBzcw%3D%3D&btag=80000e00010000&dy_q=1739030996&feature_id=aa7df520beeae8e397df15f38df0454c&l=202502090009563198B7753D5397379997";
        CJFileModel *videoFile = [[CJFileModel alloc] initWithNetworkAbsoluteUrl:Url];
        NSString *imageLocalAbsolutePath = [[NSBundle mainBundle] pathForResource:@"好听到怀孕的一人饮酒醉" ofType:@"jpg"];
        CJFileModel *firstFrameImageFile = [[CJFileModel alloc] initWithLocalAbsolutePath:imageLocalAbsolutePath sourceType:CJFileSourceTypeLocalBundle];
        
        VideoModel *videoModel = [[VideoModel alloc] init];
        videoModel.videoFile = videoFile;
        videoModel.firstFrameImageFile = firstFrameImageFile;
        [videoModels addObject:videoModel];
    }
    
    {
        CJFileModel *videoFile = [[CJFileModel alloc] initWithNetworkAbsoluteUrl:@"http://tb-video.bdstatic.com/tieba-smallvideo/1252235_a05f804362182e822679d64a34a27beb.mp4"];
        NSString *imageLocalAbsolutePath = [[NSBundle mainBundle] pathForResource:@"月光宝盒" ofType:@"jpg"];
        CJFileModel *firstFrameImageFile = [[CJFileModel alloc] initWithLocalAbsolutePath:imageLocalAbsolutePath sourceType:CJFileSourceTypeLocalBundle];
        
        VideoModel *videoModel = [[VideoModel alloc] init];
        videoModel.videoFile = videoFile;
        videoModel.firstFrameImageFile = firstFrameImageFile;
        [videoModels addObject:videoModel];
    }
    
    {
        CJFileModel *videoFile = [[CJFileModel alloc] initWithNetworkAbsoluteUrl:@"http://tb-video.bdstatic.com/tieba-smallvideo/180_b5bee2740585150a043f6bfef1c7dadf.mp4"];
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

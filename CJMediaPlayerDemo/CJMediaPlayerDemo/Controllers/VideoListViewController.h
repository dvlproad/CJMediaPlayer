//
//  VideoListViewController.h
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

// 在UITableView中, 各个cell都共享一个同样的playerView，当某个cell播放时, 我们把playerView动态加到那个cell上, 其余的cell都只显示一张封面
// MPSimplePlayerView 同样可以传入一个封面参数, 该值可以使用相同的封面, 并帮助playerView内部从封面转换到cell时更加平滑

@interface VideoListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<VideoModel *> *videoModels;

@end

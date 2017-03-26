//
//  VideoListViewController.m
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "VideoListViewController.h"
#import <PureLayout/PureLayout.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "VideoListCell.h"
#import "CJPlayerController.h"
#import "TestDataUtil.h"

@interface VideoListViewController () {
    
}
@property (nonatomic, strong) CJPlayerController *sharedPlayerController;
@property (nonatomic, assign) NSIndexPath *playingIndexPath;

@property (nonatomic, assign) BOOL allowsRotation;//播放器支持浮层旋转, 并在回到之前页面时有正确的动画

@end



@implementation VideoListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.allowsRotation = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.allowsRotation = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedString(@"VideoList", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    
    self.videoModels = [TestDataUtil getTestVideoModels];
    self.playingIndexPath = nil;
    
    [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 400;
    
    self.sharedPlayerController = [[CJPlayerController alloc] init];
    self.sharedPlayerController.view.backgroundColor = [UIColor blueColor];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITabelViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    VideoModel *videoModel = [self.videoModels objectAtIndex:indexPath.row];
    cell.titleLabel.text = [videoModel.videoFile.absoluteURL absoluteString];
    cell.coverView.image = videoModel.image;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self startVideoAtIndexPath:indexPath];
}


//当某个cell移除时候所做的操作：
//本demo使用简单的策略: 当上一个播放中的view移出时,我们会接下来选择在屏幕中间的那个cell
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == self.playingIndexPath)
    {
        //we will pick a new video to play
        NSArray<NSIndexPath *> *visibleCellIndexPaths = [tableView indexPathsForVisibleRows];
        NSUInteger visibleCellCount = visibleCellIndexPaths.count;
        if (visibleCellCount == 0) {
            return;
        }
        
        NSIndexPath *indexPathsForPlay = visibleCellIndexPaths[visibleCellCount/2];
        [self startVideoAtIndexPath:indexPathsForPlay];
    }
}

/**
 *  点击播放该位置的视频
 *
 *  @param indexPath    indexPath
 */
- (void)startVideoAtIndexPath:(NSIndexPath *)indexPath {
    self.playingIndexPath = indexPath;
    
    //如果是要播放的那个cell，则将播放视图添加到该cell上
    VideoListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.videoBackgroundView addSubview:self.sharedPlayerController.view];
    [self.sharedPlayerController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    VideoModel *videoModel = [self.videoModels objectAtIndex:indexPath.row];
    [self.sharedPlayerController setVideoURL:videoModel.videoFile.absoluteURL
                                  coverImage:videoModel.image
                                   needCache:YES
                                    maskType:CJPlayerMaskViewTypeNormal];
    [self.sharedPlayerController play];
}



#pragma mark - 旋转
//我们不推荐在弹出播放器浮层时, base view controller产生UI变动, 这样会导致播放器不容易还原到原先位置
- (BOOL)shouldAutorotate {
    return self.allowsRotation;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    if (!self.allowsRotation) {
        return;
    }
    
    [coordinator animateAlongsideTransitionInView:self.view animation:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (self.playingIndexPath != nil) {
            [self startVideoAtIndexPath:self.playingIndexPath];
        }
    } completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

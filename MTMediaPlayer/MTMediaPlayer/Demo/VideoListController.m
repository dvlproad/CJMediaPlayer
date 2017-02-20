//
//  VideoListController.m
//  MTMediaPlayer
//
//  Created by 吴君恺 on 16/3/10.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "PureLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "VideoListController.h"
#import "VideoListCell.h"
#import "CJPlayerController.h"

@interface VideoListController ()

@property (nonatomic, strong, readonly) NSArray<NSString *> *videoURLS;
@property (nonatomic, strong, readonly) NSArray<NSURL *> *videoCoverImages;
@property (nonatomic, assign) NSInteger playingCellIndex;

@property (nonatomic, strong) CJPlayerController *sharedPlayerView;
@property (nonatomic, assign) BOOL allowsRotation;//播放器支持浮层旋转, 并在回到之前页面时有正确的动画

@end

@implementation VideoListController

@synthesize videoURLS = _videoURLS;
@synthesize videoCoverImages = _videoCoverImages;

// 在UITableView中, 各个cell都共享一个同样的playerView,
// 当某个cell播放时, 我们把playerView动态加到那个cell上, 其余的cell都只显示一张封面

// MPSimplePlayerView 同样可以传入一个封面参数, 该值可以使用相同的封面, 并帮助playerView内部从封面转换到cell时更加平滑

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Videos Cells";
        _playingCellIndex = -1;
        self.navigationItem.leftBarButtonItem =
        	[[UIBarButtonItem alloc] initWithTitle:@"back"
            	style:UIBarButtonItemStylePlain
                target:self
                action:@selector(back)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 400;
    [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:@"reuseID"];
     
    _sharedPlayerView = [[CJPlayerController alloc] init];
    _sharedPlayerView.view.translatesAutoresizingMaskIntoConstraints = NO;
    _sharedPlayerView.view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_sharedPlayerView.view];
    [_sharedPlayerView.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    if (!self.allowsRotation) {
        return;
    }

    [coordinator animateAlongsideTransitionInView:self.view
        animation:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            if (self.playingCellIndex >= 0) {
                [self startVideoInCell:nil WithIndex:self.playingCellIndex];
            }
        }
        completion:nil];
}

// 我们不推荐在弹出播放器浮层时, base view controller产生UI变动, 这样会导致播放器不容易还原到原先位置
- (BOOL)shouldAutorotate {
    return self.allowsRotation;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.allowsRotation = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.allowsRotation = NO;
}

- (NSArray *)videoURLS {
    if (!_videoURLS) {
        _videoURLS = @[
//            @"https://mvvideo5.meitudata.com/550687c96ffd28130.mp4",
        	@"http://beauty1.meitudata.com/b5efb8ebc7716683808971fd9f6fd7f5.mp4",
            @"http://mvvideo4.meitudata.com/5664b438390f77375.mp4",
            @"http://mvvideo5.meitudata.com/56d9292d529c48134.mp4",
            @"https://mvvideo5.meitudata.com/56de8739217626422.mp4",
            @"https://mvvideo5.meitudata.com/56de8b2d38a6f8873.mp4"
        ];
    }
    return _videoURLS;
}

- (NSArray<NSURL *> *)videoCoverImages {
    if (!_videoCoverImages) {
        NSMutableArray *covers = [NSMutableArray array];
        for (int i = 0; i < self.videoURLS.count; ++i) {
            NSString *coverImageFileName = [NSString stringWithFormat:@"%d", i];
            NSURL *coverImageURL = [[NSBundle mainBundle] URLForResource:coverImageFileName
                                                           withExtension:@"png"];
            [covers addObject:coverImageURL];
        }
        _videoCoverImages = covers;
    }
    return _videoCoverImages;
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoURLS.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseID"];
    cell.titleLabel.text = self.videoURLS[indexPath.row];
    [cell.coverView sd_setImageWithURL:self.videoCoverImages[indexPath.row]];
    
    if (indexPath.row == self.playingCellIndex) {
        [cell.videoBackgroundView addSubview:_sharedPlayerView.view];
        [_sharedPlayerView.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self startVideoInCell:cell WithIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView
	didEndDisplayingCell:(UITableViewCell *)cell
	forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 本demo使用简单的策略: 当上一个播放中的view移出时,我们会接下来选择在屏幕中间的那个cell
    if (indexPath.row == self.playingCellIndex) {
        // we will pick a new video to play
        NSArray<NSIndexPath *> *visibleCellIndexPaths = [tableView indexPathsForVisibleRows];
        NSUInteger visibleCellCount = visibleCellIndexPaths.count;
        if (visibleCellCount == 0) {
            return;
        }
        
        NSIndexPath *indexPathsForPlay = visibleCellIndexPaths[visibleCellCount / 2];
        [self startVideoInCell:nil WithIndex:indexPathsForPlay.row];
    }
}


- (void)startVideoInCell:(VideoListCell *)cell WithIndex:(NSInteger)index {
    self.playingCellIndex = index;
    if (!cell) {
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    }
    
    _sharedPlayerView.view.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.videoBackgroundView addSubview:_sharedPlayerView.view];
    [_sharedPlayerView.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    NSURL *coverImageURL = self.videoCoverImages[index];
    NSData *coverImageData = [NSData dataWithContentsOfURL:coverImageURL];
    UIImage *coverImage = [UIImage imageWithData:coverImageData];
    [_sharedPlayerView setURL:[NSURL URLWithString:self.videoURLS[index]]
                   coverImage:coverImage
                    needCache:YES
                     maskType:CJPlayerMaskViewTypeNormal];
    [_sharedPlayerView play];
}




@end

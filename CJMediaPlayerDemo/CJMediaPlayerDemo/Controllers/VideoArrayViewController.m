//
//  DemoViewController.m
//  TBPlayer
//
//  Created by dvlproad on 16/3/23.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "VideoArrayViewController.h"

#import "VideoModel.h"
#import "VideoTableViewCell.h"


@interface VideoArrayViewController ()


@property(nonatomic, strong)NSArray *videoArr;
@property(nonatomic, strong)NSIndexPath *curPlayIndexPath;

@end

@implementation VideoArrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.curPlayIndexPath = nil;
    
    self.videoArr =
    @[
      
      [[VideoModel alloc] initWithVideoUrl:@"http://tb-video.bdstatic.com/tieba-smallvideo/86_671b0a2e1eab73e48eb3aafcbae5dcaa.mp4"],
      [[VideoModel alloc] initWithVideoUrl:@"http://tb-video.bdstatic.com/tieba-smallvideo/86_671b0a2e1eab73e48eb3aafcbae5dcaa.mp4"],

      [[VideoModel alloc] initWithVideoUrl:@"http://tb-video.bdstatic.com/tieba-smallvideo/86_671b0a2e1eab73e48eb3aafcbae5dcaa.mp4"],
      [[VideoModel alloc] initWithVideoUrl:@"http://tb-video.bdstatic.com/tieba-smallvideo/86_671b0a2e1eab73e48eb3aafcbae5dcaa.mp4"],
      
      [[VideoModel alloc] initWithVideoUrl:@"http://tb-video.bdstatic.com/tieba-smallvideo/86_671b0a2e1eab73e48eb3aafcbae5dcaa.mp4"],
    ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDataSource


- (void)configureCell:(VideoTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.curPlayIndexPath isEqual:indexPath]) {
        [cell reset];
    }
    cell.videoModel = self.videoArr[indexPath.row];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoTableViewCell" forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];

    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [VideoTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (![self.curPlayIndexPath isEqual:indexPath]) {
        VideoTableViewCell *cell = [tableView cellForRowAtIndexPath:self.curPlayIndexPath];
        [cell.playerView stop];
    }
    
    self.curPlayIndexPath = indexPath;
    VideoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.playerView playOrPause];
}

@end

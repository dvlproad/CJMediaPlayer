//
//  DemoViewController.m
//  TBPlayer
//
//  Created by dvlproad on 16/3/23.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "VideoViewController.h"

#import "VideoModel.h"
#import "VideoTableViewCell.h"


@interface VideoViewController ()


@property(nonatomic, strong)NSArray *videoArr;
@property(nonatomic, strong)NSIndexPath *curPlayIndexPath;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.curPlayIndexPath = nil;
    
    self.videoArr =
    @[
      
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo2.meitudata.com/56e91a0b9ae8c3071.mp4"],
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo1.meitudata.com/56ed7ac9e78785446.mp4"],

      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo1.meitudata.com/56f16b7b6b4f03558.mp4"],
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo2.meitudata.com/56e9146788ebd7752.mp4"],
      
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo1.meitudata.com/56f121c24b1cc9355.mp4"],
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo1.meitudata.com/56f24263d885e2747.mp4"],
      
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo1.meitudata.com/56e816b2bbf195086.mp4"],
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo2.meitudata.com/56e815482901a7702.mp4"],
      
      
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo2.meitudata.com/56e8fd2cd9a016644.mp4"],
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo1.meitudata.com/56c1a1ca3acf77824.mp4"],
      
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo2.meitudata.com/56e91031cf3493886.mp4"],
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo1.meitudata.com/56e90f841e92d8996.mp4"],
      
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo1.meitudata.com/56e9aa1ba0e177307.mp4"],
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo2.meitudata.com/56e9bf776d1d46595.mp4"],
      
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo2.meitudata.com/56f23fc077e80144.mp4"],
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo1.meitudata.com/56f24b4ac6864699.mp4"],
      
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo1.meitudata.com/56f21a9dae7ab6626.mp4"],
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo2.meitudata.com/56f207211ae921593.mp4"],

      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo1.meitudata.com/56f1fa1096fd46959.mp4"],
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo2.meitudata.com/56f1f9be41adb970.mp4"],
      
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo2.meitudata.com/56f18ca222a144148.mp4"],
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo1.meitudata.com/56eef779181277009.mp4"],
      
      [[VideoModel alloc] initWithVideoUrl:@"http://mvvideo2.meitudata.com/56f103d8d2cf51799.mp4"],

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

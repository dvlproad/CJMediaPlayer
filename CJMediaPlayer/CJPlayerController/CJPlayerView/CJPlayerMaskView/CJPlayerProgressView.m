//
//  CJPlayerProgressBar.m
//  MTMediaPlayer
//
//  Created by lichq on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJPlayerProgressView.h"

#import <PureLayout.h>
#import "HexColor.h"

@interface CJPlayerProgressView () {
    
}
@property (nonatomic, strong) UILabel *startTimeLabel;      /**< 开始时间 */
@property (nonatomic, strong) UILabel *totalTimeLabel;      /**< 总时间 */
@property (nonatomic, strong) CJPlayerSlider *playerSlider; /**< 进度条 */

@end



@implementation CJPlayerProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _startTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_startTimeLabel setFont:[UIFont systemFontOfSize:12.0f]];
        _startTimeLabel.textAlignment = NSTextAlignmentCenter;
        _startTimeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_startTimeLabel];
        
        _playerSlider = [[CJPlayerSlider alloc] initWithFrame:CGRectZero];
        _playerSlider.enableTip = NO;
        _playerSlider.minimumTrackTintColor = [UIColor colorWithHexString:@"ff4b51"];
        [self addSubview:_playerSlider];
        
        _totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_totalTimeLabel setFont:[UIFont systemFontOfSize:12.0f]];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_totalTimeLabel];
        
        //setupLayoutConstraints
        self.startTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.startTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.startTimeLabel autoSetDimension:ALDimensionWidth toSize:50.0f];
        [self.startTimeLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.startTimeLabel autoSetDimension:ALDimensionHeight toSize:32.0f];
        
        self.totalTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.totalTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.totalTimeLabel autoSetDimension:ALDimensionWidth toSize:50.0f];
        [self.totalTimeLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.totalTimeLabel autoSetDimension:ALDimensionHeight toSize:32.0f];
        
        self.playerSlider.translatesAutoresizingMaskIntoConstraints = NO;
        [self.playerSlider autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:50.0f];
        [self.playerSlider autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:50.0f];
        [self.playerSlider autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.playerSlider autoSetDimension:ALDimensionHeight toSize:32.0f];
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.startTimeLabel.text = @"00.00";
    self.totalTimeLabel.text = @"00.00";
    self.playerSlider.value = 0;
}

/** 完整的描述请参见文件头部 */
- (void)resetValue {
    [self commonInit];
}

- (void)setPlayerSliderDelegate:(id<CJPlayerSliderDelegate>)playerSliderDelegate {
    self.playerSlider.delegate = playerSliderDelegate;
}

/** 完整的描述请参见文件头部 */
- (void)updateStartTime:(NSInteger)time {
    self.startTimeLabel.text = [self timeFormatFromSeconds:time];
}

/** 完整的描述请参见文件头部 */
- (void)updateTotalTime:(NSInteger)time {
    self.totalTimeLabel.text = [self timeFormatFromSeconds:time];
}

/** 完整的描述请参见文件头部 */
- (void)updateSliderValue:(CGFloat)value {
    self.playerSlider.value = value;
}

#pragma mark - Private
/**
 *  把秒换算成时分字符串的函数
 *
 *  @param seconds 要转换成字符串的秒值
 *
 *  @return 秒转换后的字符串
 */
- (NSString *)timeFormatFromSeconds:(NSInteger)seconds {
    // format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld", (seconds % 3600) / 60];
    // format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld", seconds % 60];
    // format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@", str_minute, str_second];
    
    return format_time;
}

@end

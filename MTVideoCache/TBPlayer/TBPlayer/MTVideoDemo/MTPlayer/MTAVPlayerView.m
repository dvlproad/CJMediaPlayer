//
//  MTAVPlayerView.m
//  TestTableView
//
//  Created by dvlproad on 16/3/9.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "MTAVPlayerView.h"
#import "MTAVPlayerController.h"


static NSString *kKVOKeyPathPlayerStatus = @"playerStatus";

@interface MTAVPlayerView ()



@property (nonatomic, strong) UIImageView *posterImageView;             //海报
@property (nonatomic, strong) UIImageView *playIconImageView;           //播放图标

@property (nonatomic, strong) UISlider *playProgressSlider;             //播放进度滑块
@property (nonatomic, strong) UILabel *totalTimeLabel;                  //总时间
@property (nonatomic, strong) UILabel *playTimeLabel;                   //已播放时间
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;   //等待框


- (void)showPoster:(BOOL)isShow;
- (void)showLoading;
- (void)hideLoading;


@end


@implementation MTAVPlayerView

- (void)dealloc
{
    
    [self removeObserver:self forKeyPath:kKVOKeyPathPlayerStatus];
    
    
    [self.posterImageView removeFromSuperview];
    [self.playProgressSlider removeFromSuperview];
    [self.totalTimeLabel removeFromSuperview];
    [self.playTimeLabel removeFromSuperview];
    [self.indicatorView removeFromSuperview];

    self.posterImageView    = nil;
    self.playProgressSlider = nil;
    self.totalTimeLabel     = nil;
    self.playTimeLabel      = nil;
    self.indicatorView      = nil;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInit];
        
    }
    return self;
}


+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}



- (void)commonInit
{
    //添加KVO
    [self addObserver:self
           forKeyPath:kKVOKeyPathPlayerStatus
              options:NSKeyValueObservingOptionNew 
              context:nil];
    
    
    self.playerStatus = MTAVPlayerStateUnStart; //未开始

    //海报
    self.posterImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.posterImageView setImage:[UIImage imageNamed:@"testPoster.jpg"]];
    
    //播放图标
    self.playIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"testPlayIcon.jpg"]];
    self.playIconImageView.frame = CGRectMake(0, 0, 50, 50);

    //播放进度滑块
    self.playProgressSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    self.playProgressSlider.minimumValue = 0.0;
    self.playProgressSlider.maximumValue = 1.0;
    
    self.playProgressSlider.minimumTrackTintColor = [UIColor blueColor];
    self.playProgressSlider.maximumTrackTintColor = [UIColor whiteColor];
    
    //按下滑块
    [self.playProgressSlider addTarget:self
                                action:@selector(playSliderChangedStart:)
                      forControlEvents:UIControlEventTouchDown];
    
    //滑动滑块时滑动值发生改变
    [self.playProgressSlider addTarget:self
                                action:@selector(playSliderChanging:)
                      forControlEvents:UIControlEventValueChanged];
    
    //松开滑块
    [self.playProgressSlider addTarget:self
                                action:@selector(playSliderChangedEnd:)
                      forControlEvents:UIControlEventTouchUpInside];
    
    //松开滑块
    [self.playProgressSlider addTarget:self
                                action:@selector(playSliderChangedEnd:)
                      forControlEvents:UIControlEventTouchUpOutside];
    
    //取消
    [self.playProgressSlider addTarget:self
                                action:@selector(playSliderChangedEnd:)
                      forControlEvents:UIControlEventTouchCancel];
    
    
    

    self.totalTimeLabel               = [[UILabel alloc] initWithFrame:CGRectZero];
    self.totalTimeLabel.textColor     = [UIColor blackColor];
    self.totalTimeLabel.font          = [UIFont systemFontOfSize:11];
    self.totalTimeLabel.textAlignment = NSTextAlignmentLeft;


    self.playTimeLabel                = [[UILabel alloc] initWithFrame:CGRectZero];
    self.playTimeLabel.textColor      = [UIColor blackColor];
    self.playTimeLabel.font           = [UIFont systemFontOfSize:11];
    self.playTimeLabel.textAlignment  = NSTextAlignmentRight;
    

    self.indicatorView =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    
    [self addSubview:self.posterImageView];
    [self addSubview:self.playIconImageView];
    
    [self addSubview:self.playProgressSlider];
    [self addSubview:self.totalTimeLabel];
    [self addSubview:self.playTimeLabel];
    
    [self addSubview:self.indicatorView];
    
    [self clean];
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect bounds = self.bounds;
    self.posterImageView.frame = bounds;

    CGFloat height = CGRectGetHeight(bounds) - 30;
    
    CGRect progressFrame = CGRectMake(40, height, CGRectGetWidth(bounds) - 40*2, 30);
    self.playProgressSlider.frame = progressFrame;
    
    CGRect playTimeFrame = CGRectMake(0, height, 38, 30);
    self.playTimeLabel.frame = playTimeFrame;
    
    CGRect totalTimeFrame = CGRectMake(CGRectGetWidth(bounds) - 38, height, 38, 30);
    self.totalTimeLabel.frame = totalTimeFrame;
    
    //居中
    CGPoint center = CGPointMake(CGRectGetWidth(bounds)/2, CGRectGetHeight(bounds)/2);
    self.indicatorView.center = center;
    self.self.playIconImageView.center = center;
    
}



#pragma mark - KVO


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kKVOKeyPathPlayerStatus]) {
        
        switch (self.playerStatus) {
            case MTAVPlayerStateUnStart:
            {
                //未开始时，显示海报,播放图标, 隐藏菊花等待
                [self showPoster:YES];
                [self showPlayIcon:YES];
                [self hideLoading];
                
                [self clean];
                
                break;
            }
            case MTAVPlayerStateBuffering:
            {
                //缓冲,隐藏海报和播放图标，并显示菊花等待
                [self showPoster:NO];
                [self showPlayIcon:NO];
                [self showLoading];
                break;
            }
            case MTAVPlayerStatePlaying:
            {
                //播放,隐藏海报和图标，停止并隐藏菊花等待
                [self showPoster:NO];
                [self showPlayIcon:NO];
                [self hideLoading];
                break;
            }
            case MTAVPlayerStatePause:
            {
                //暂停，隐藏海报，显示播放按钮, 隐藏菊花等待
                [self showPoster:NO];
                [self showPlayIcon:YES];
                [self hideLoading];
                break;
            }
            case MTAVPlayerStateSlidePause:
            {
                //滑动暂停，隐藏海报，隐藏播放按钮, 隐藏菊花等待
                [self showPoster:NO];
                [self showPlayIcon:NO];
                [self hideLoading];
                break;
            }
                
            default:
                break;
        }
        
    }
}






#pragma mark - Private


- (void)showPoster:(BOOL)isShow
{
    [self.posterImageView setHidden:!isShow];
}


- (void)showPlayIcon:(BOOL)isShow
{
    [self.playIconImageView setHidden:!isShow];
}

- (void)showLoading
{
    [self.indicatorView setHidden:NO];
    [self.indicatorView startAnimating];
}

- (void)hideLoading
{
    [self.indicatorView stopAnimating];
    [self.indicatorView setHidden:YES];
}





#pragma mark - Public

- (void)play
{
    //显示进度条
    [self.playProgressSlider setHidden:NO];

    //获取URL,并开始播放
    NSString *url = self.getVideoUrl();
    MTAVPlayerController *playerController = [MTAVPlayerController sharedInstance];
    [playerController playWithMediaUrl:[NSURL URLWithString:url] OnPlayerView:self];

}


- (void)resume
{
    MTAVPlayerController *playerController = [MTAVPlayerController sharedInstance];
    [playerController resume];

}


- (void)pause
{
    //暂停
    MTAVPlayerController *playerController = [MTAVPlayerController sharedInstance];
    [playerController pause];

}



- (void)slidePause
{
    //滑动暂停
    MTAVPlayerController *playerController = [MTAVPlayerController sharedInstance];
    [playerController slidePause];
}

- (void)stop
{
    
    self.playerStatus = MTAVPlayerStateUnStart;
    
    //停止
    MTAVPlayerController *playerController = [MTAVPlayerController sharedInstance];
    [playerController stop];
    [self clean];

}



- (void)clean
{
    //清理
    self.playTimeLabel.text = @"";
    self.totalTimeLabel.text = @"";
    
    //进度清0，并隐藏
    [self updateProgressSlider:0];
    [self.playProgressSlider setHidden:YES];

    //隐藏
    [self.indicatorView setHidden:YES];
    
}


- (void)seekToTime:(CGFloat)seconds
{
    //seek播放
    MTAVPlayerController *playerController = [MTAVPlayerController sharedInstance];
    [playerController seekToTime:seconds];
}



#pragma mark -

- (void)playOrPause
{
    
    switch (self.playerStatus) {
        case MTAVPlayerStateUnStart:
        {
            //开始播放
            [self play];
            break;
        }
        case MTAVPlayerStateBuffering:
        {
            //暂停
            [self pause];
            break;
        }
        case MTAVPlayerStatePause:
        case MTAVPlayerStateSlidePause:
        {
            //继续播放
            [self resume];
            break;
        }
        case MTAVPlayerStatePlaying:
        {
            //暂停
            [self pause];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 控件拖动

- (void)setPlaySliderMaxValue:(CGFloat)maxValue
{
    NSLog(@"---------------maxTime = %lf", maxValue);
    self.playProgressSlider.minimumValue = 0.0;
    self.playProgressSlider.maximumValue = maxValue;
}


- (void)updateProgressSlider:(CGFloat)currentSecond
{
    NSLog(@"---------------curTime = %lf", currentSecond);
    [self.playProgressSlider setValue:currentSecond animated:YES];
}


//开始拖动
- (void)playSliderChangedStart:(UISlider *)slider
{
    //暂停播放
    if (self.playerStatus == MTAVPlayerStatePause) {
        [self pause];
    } else {
        [self slidePause];
    }
}


//结束拖动
- (void)playSliderChangedEnd:(UISlider *)slider
{
    [self updateCurrentTime:slider.value];
    
    //seek播放
    [self seekToTime:slider.value];

}

//手指正在拖动
- (void)playSliderChanging:(UISlider *)slider
{
    [self updateCurrentTime:slider.value];
}


#pragma mark - 更新时间


- (void)updateCurrentTime:(CGFloat)time
{
    long videocurrent = ceil(time);
    
    NSString *str = nil;
    if (videocurrent < 3600) {
        str =  [NSString stringWithFormat:@"%02li:%02li",lround(floor(videocurrent/60.f)),lround(floor(videocurrent/1.f))%60];
    } else {
        str =  [NSString stringWithFormat:@"%02li:%02li:%02li",lround(floor(videocurrent/3600.f)),lround(floor(videocurrent%3600)/60.f),lround(floor(videocurrent/1.f))%60];
    }
    
    self.playTimeLabel.text = str;
}

- (void)updateTotalTime:(CGFloat)time
{
    long videoLenth = ceil(time);
    NSString *str = nil;
    if (videoLenth < 3600) {
        str =  [NSString stringWithFormat:@"%02li:%02li",lround(floor(videoLenth/60.f)),lround(floor(videoLenth/1.f))%60];
    } else {
        str =  [NSString stringWithFormat:@"%02li:%02li:%02li",lround(floor(videoLenth/3600.f)),lround(floor(videoLenth%3600)/60.f),lround(floor(videoLenth/1.f))%60];
    }
    
    self.totalTimeLabel.text = str;
}



@end

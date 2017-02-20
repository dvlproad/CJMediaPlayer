//
//  CJPlayerViewController.m
//  MTMediaPlayer
//
//  Created by lichq on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJPlayerViewController.h"
#import <PureLayout.h>

typedef NS_ENUM(NSInteger, LayoutConstraintsStatus){
    LayoutConstraintsStatusOrigin = 0, /**< 初始时候的约束 */
    LayoutConstraintsStatusFullScreen /**< 全屏时候的约束 */
};

@interface CJPlayerViewController() <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
{
    struct {
        unsigned int statusbarHiddenInitially: 1;
        unsigned int animatedDismissing: 1;
    } _flags;
    
    CGRect _dismissalTargetFrame;   // 退出时的frame
    UIStatusBarStyle _originalStatusBarStyle;
    
    NSMutableArray<NSLayoutConstraint *> *_originVideoPlayerViewLayoutConstraints;
    NSMutableArray<NSLayoutConstraint *> *_targetOldParentViewLayoutConstraints;
    NSMutableArray<NSLayoutConstraint *> *_fullScreenVideoPlayerViewLayoutConstraints;
}

@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, assign) UIDeviceOrientation currentOrientation;

@property (nonatomic, strong) UIView *targetOldParentView;

@end

@implementation CJPlayerViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithPlayerController:(CJPlayerController *)playerController {
    if (self = [self init]) {
        self.videoPlayerView = playerController.view;
        _targetOldParentView = playerController.view.superview;
        
        _targetOldParentViewLayoutConstraints = [[NSMutableArray alloc] init];
        for (NSLayoutConstraint *layoutConstraint in _targetOldParentView.constraints) {
            if (layoutConstraint.firstItem == self.videoPlayerView || layoutConstraint.secondItem == self.videoPlayerView) {
                [_targetOldParentViewLayoutConstraints addObject:layoutConstraint];
            }
        }
        
        _originVideoPlayerViewLayoutConstraints = [[NSMutableArray alloc] init];
        for (NSLayoutConstraint *layoutConstraint in self.videoPlayerView.constraints) {
            if (layoutConstraint.firstItem == self.videoPlayerView) {
                [_originVideoPlayerViewLayoutConstraints addObject:layoutConstraint];
            }
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.backgroundView];
}

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        _backgroundView.backgroundColor = [UIColor blackColor];
    }
    return _backgroundView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BOOL statusBarAnimation = YES;
    _originalStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:statusBarAnimation];
    [self hideStatusBarAnimated:NO];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:_originalStatusBarStyle];
    [[UIApplication sharedApplication] setStatusBarHidden:_flags.statusbarHiddenInitially withAnimation:UIStatusBarAnimationNone];
}

- (void)hideStatusBarAnimated:(BOOL)animated
{
    _flags.statusbarHiddenInitially = [UIApplication sharedApplication].statusBarHidden;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
}

- (void)presentFromViewController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^)(void))completion
{
    self.transitioningDelegate = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
    [controller presentViewController:self animated:animated completion:completion];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _flags.animatedDismissing = YES;
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return [transitionContext isAnimated] ? 0.5 : 0.0;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    if (_flags.animatedDismissing) {
        [self animateDismissTransition:transitionContext duration:duration];
    } else {
        [self animatePresentTransition:transitionContext duration:duration];
    }
}

- (void)animatePresentTransition:(id <UIViewControllerContextTransitioning>)transitionContext duration:(NSTimeInterval)duration
{
    UIView * containerView = [transitionContext containerView];
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [containerView addSubview:toViewController.view];
    
    UIView *playerView = self.videoPlayerView;
    CGRect sourceFrame = [playerView convertRect:playerView.bounds toView:self.view];
    _dismissalTargetFrame = sourceFrame;
    
    [self.view addSubview:playerView];
    [self setVideoPlayerViewLayoutConstraints:LayoutConstraintsStatusFullScreen];
    [self.view setNeedsLayout];
    _backgroundView.alpha = 0.0;
    
    void (^updates)(void) = ^{
        [self.view layoutIfNeeded];
        _backgroundView.alpha = 1.0;
    };
    
    void (^completion)(BOOL) = ^(BOOL finished){
        [transitionContext completeTransition:YES];
    };
    
    if (duration) {
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionLayoutSubviews
                         animations:updates
                         completion:completion];
    } else {
        updates();
        completion(YES);
    }
}

- (void)animateDismissTransition:(id <UIViewControllerContextTransitioning>)transitionContext duration:(NSTimeInterval)duration
{
    UIViewController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    fromViewController.view.backgroundColor = [UIColor clearColor];
    UIView *playerView = self.videoPlayerView;
    
    [self updatePlayerViewLayoutConstraintsForExitFullScreen];
    [self.view setNeedsLayout];
    void (^updates)(void) = ^{
        [self.view layoutIfNeeded];
        _backgroundView.alpha = 0.0;
    };
    
    void (^completion)(BOOL) = ^(BOOL finished){
        [_targetOldParentView addSubview:playerView];
        [self setVideoPlayerViewLayoutConstraints:LayoutConstraintsStatusOrigin];
        [_targetOldParentView layoutIfNeeded];
        [fromViewController.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    };
    
    if (duration) {
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:updates
                         completion:completion];
    } else {
        updates();
        completion(YES);
    }
}


- (void)updatePlayerViewLayoutConstraintsForExitFullScreen {
    _fullScreenVideoPlayerViewLayoutConstraints = [[NSMutableArray alloc] init];
    for (NSLayoutConstraint *layoutConstraint in self.view.constraints) {
        if (layoutConstraint.firstItem == self.videoPlayerView || layoutConstraint.secondItem == self.videoPlayerView) {
            [_fullScreenVideoPlayerViewLayoutConstraints addObject:layoutConstraint];
        }
    }
    [self.view removeConstraints:_fullScreenVideoPlayerViewLayoutConstraints];
    
    
    CGFloat top = _dismissalTargetFrame.origin.y;
    CGFloat left = _dismissalTargetFrame.origin.x;
    CGFloat right = CGRectGetWidth(self.view.frame) - CGRectGetMaxX(_dismissalTargetFrame);
    CGFloat bottom = CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_dismissalTargetFrame);
    [self.videoPlayerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(top, left, bottom, right)];
}


- (void)setVideoPlayerViewLayoutConstraints:(LayoutConstraintsStatus)status {
    if (status == LayoutConstraintsStatusFullScreen) {  /** 全屏时候的约束 */
        [self.videoPlayerView removeConstraints:_originVideoPlayerViewLayoutConstraints];
        [self.videoPlayerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }else {                                             /** 初始时候的约束 */
        [self.videoPlayerView addConstraints:_originVideoPlayerViewLayoutConstraints];
        [_targetOldParentView addConstraints:_targetOldParentViewLayoutConstraints];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

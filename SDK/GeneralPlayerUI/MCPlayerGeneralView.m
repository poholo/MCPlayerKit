//
// Created by majiancheng on 2017/3/17.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "MCPlayerGeneralView.h"

#import <MCStyle/MCStyleDef.h>

#import "MCPlayerGeneralHeader.h"
#import "MCPlayerGeneralFooter.h"
#import "MCPlayerGeneralTouchView.h"
#import "MCRotateHelper.h"
#import "MCPlayerKit.h"
#import "MCPlayerLoadingView.h"
#import "MCPlayerProgress.h"

@interface MCPlayerGeneralView () <MCPlayerDelegate>

@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) MCPlayerGeneralTouchView *touchView;
@property(nonatomic, strong) MCPlayerView *playerView;
@property(nonatomic, strong) MCPlayerLoadingView *loadingView;

@property(nonatomic, strong) MCPlayerGeneralHeader *topView;
@property(nonatomic, strong) MCPlayerGeneralFooter *bottomView;
@property(nonatomic, strong) MCPlayerProgress *bottomProgress;
@property(nonatomic, strong) UIButton *lockBtn;
@property(nonatomic, strong) UIButton *playBtn;
@property(nonatomic, strong) UIView *definitionView;

@property(nonatomic, weak) MCPlayerKit *playerKit;


@end

@implementation MCPlayerGeneralView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self createViews];
    [self addLayout];
    [self addActions];
    [self.loadingView startRotating];
}

- (void)updatePlayerStyle:(MCPlayerStyleSizeType)styleSizeType {
    if (self.styleSizeType == styleSizeType) return;
    self.styleSizeType = styleSizeType;
    [self.topView updatePlayerStyle:styleSizeType];
    [self.bottomView updatePlayerStyle:styleSizeType];
    switch (self.styleSizeType) {
        case PlayerStyleSizeClassRegularHalf: {
            self.lockBtn.hidden = YES;
            self.playBtn.hidden = self.bottomView.hidden;
        }
            break;
        case PlayerStyleSizeClassRegular: {
            self.lockBtn.hidden = self.bottomView.hidden;
            self.playBtn.hidden = YES;
        }
            break;
        case PlayerStyleSizeClassCompact: {
            self.lockBtn.hidden = self.bottomView.hidden;
            self.playBtn.hidden = YES;
        }
            break;
    }
}

- (void)updateTitle:(NSString *)title {
    self.topView.titleLabel.text = title;
}

- (BOOL)isLock {
    return self.lockBtn.selected;
}

- (void)currentTime:(double)time {
    float progress = (float) (time / self.playerKit.duration);
    float buffer = (float) (self.playerKit.cacheProgress);
    [self updateProgress:progress];
    [self updateBufferProgress:buffer];
    [self.bottomProgress updateProgress:progress];
    [self.bottomProgress updateBufferProgress:buffer];
    [self.bottomView currentTime:time];
}

- (void)duration:(double)time {
    [self.bottomView duration:time];
}

- (void)updateProgress:(float)progress {
    [self.bottomView updateProgress:progress];
}

- (void)updateBufferProgress:(float)progress {
    [self.bottomView updateBufferProgress:progress];
}

- (void)updateAction:(MCPlayerKit *)playerKit {
    self.playerKit = playerKit;
    self.playerKit.delegate = self;
}

- (void)updatePlayerPicture:(NSString *)url {
    [self.loadingView updatePlayerPicture:url];
}

#pragma mark -

- (void)rotate2Landscape {
    if (self.styleSizeType == PlayerStyleSizeClassCompact) {
        return;
    }
    [MCRotateHelper setStatusBarHidden:YES];

    [self updatePlayerStyle:PlayerStyleSizeClassCompact];
    self.frame = [UIScreen mainScreen].bounds;
}

- (void)rotate2Portrait {
    [MCRotateHelper setStatusBarHidden:NO];
    CGSize size = [UIScreen mainScreen].bounds.size;
    [self updatePlayerStyle:PlayerStyleSizeClassRegularHalf];
    self.frame = CGRectMake(0, 0, size.width, size.width * 9 / 16);
}

- (void)rotate2PortraitFullScreen {
    [MCRotateHelper setStatusBarHidden:YES];
    [self updatePlayerStyle:PlayerStyleSizeClassRegular];
    self.frame = [UIScreen mainScreen].bounds;
}

#pragma mark - views

- (void)createViews {
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.playerView];
    [self.containerView addSubview:self.touchView];
    [self.containerView addSubview:self.topView];
    [self.containerView addSubview:self.bottomView];
    [self.containerView addSubview:self.lockBtn];
    [self.containerView addSubview:self.playBtn];
    [self.containerView addSubview:self.bottomProgress];
    [self.containerView addSubview:self.definitionView];

    [self.containerView addSubview:self.loadingView];
}

- (void)addLayout {
    if (CGRectIsEmpty(self.frame)) return;
    self.containerView.frame = self.bounds;
    //TODO:: 2018 devices
    self.touchView.frame = self.containerView.bounds;
    self.playerView.frame = self.containerView.bounds;
    CGFloat w = CGRectGetWidth(self.containerView.frame);
    CGFloat h = CGRectGetHeight(self.containerView.frame);
    CGFloat barRate = 0.1f;
    CGFloat barHeight = 44;
    self.topView.frame = CGRectMake(0, 0, w, barHeight + self.topView.top);
    self.bottomView.frame = CGRectMake(0, h - barHeight, w, barHeight);
    self.bottomProgress.frame = CGRectMake(0, h - 2, w, 2);

    CGFloat lockW = 44;
    self.lockBtn.frame = CGRectMake(10, (h - lockW) / 2.0f, lockW, lockW);
    CGFloat playW = 44;
    self.playBtn.frame = CGRectMake((CGRectGetWidth(self.frame) - playW) / 2.0f, (CGRectGetHeight(self.frame) - playW) / 2.0f, playW, playW);
    self.loadingView.frame = self.containerView.bounds;
}

- (void)addActions {
    __weak typeof(self) weakSelf = self;
    self.topView.callBack = ^id(NSString *action, id value) {
        __strong typeof(weakSelf) strongself = weakSelf;
        if ([action isEqualToString:kMCPlayerHeaderBack2Half]) {
            [MCRotateHelper updatePlayerRegularHalf];
            [strongself updatePlayerStyle:PlayerStyleSizeClassRegularHalf];
        } else if ([action isEqualToString:kMCPlayerHeaderBack]) {
            UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *navigationController;
            if ([viewController isKindOfClass:[UINavigationController class]]) {
                navigationController = (UINavigationController *) viewController;
            } else if (viewController.navigationController) {
                navigationController = viewController.navigationController;
            }
            if (navigationController) {
                [navigationController popViewControllerAnimated:YES];
            } else {
                //TODO test presentDismiss
                [viewController dismissViewControllerAnimated:YES completion:NULL];
            }
        }
        if (strongself.eventCallBack) {
            strongself.eventCallBack(action, value);
        }
        return nil;
    };

    self.touchView.callBack = ^id(NSString *action, id value) {
        __strong typeof(weakSelf) strongself = weakSelf;
        if ([action isEqualToString:kMCTouchTapAction]) {
            [strongself showControlThenHide];
        }
        if (strongself.eventCallBack) {
            return strongself.eventCallBack(action, value);
        }
        return nil;
    };

    self.bottomView.callBack = ^id(NSString *action, id value) {
        __strong typeof(weakSelf) strongself = weakSelf;
        if ([action isEqualToString:kMCPlayer2HalfScreenAction]) {
            [MCRotateHelper updatePlayerRegularHalf];
            [strongself updatePlayerStyle:PlayerStyleSizeClassRegularHalf];
            [strongself showControlThenHide];
        } else if ([action isEqualToString:kMCPlayer2FullScreenAction]) {
            //TODO:: 竖屏全屏
            [MCRotateHelper updatePlayerRegular];
            [strongself updatePlayerStyle:PlayerStyleSizeClassCompact];
            [strongself showControlThenHide];
        } else if ([action isEqualToString:kMCPlayer2PlayAction]) {
            strongself.playBtn.selected = strongself.bottomView.playBtn.selected;
            [strongself showControlThenHide];
        } else if ([action isEqualToString:kMCPlayer2PauseAction]) {
            strongself.playBtn.selected = strongself.bottomView.playBtn.selected;
            [strongself showControlThenHide];
        } else if ([action isEqualToString:kMCControlProgressStartDragSlider]) {
            [strongself showControl];
        } else if ([action isEqualToString:kMCDragProgressToProgress]) {
            [strongself.playerKit seekSeconds:strongself.playerKit.duration * [value floatValue]];
        } else if ([action isEqualToString:kMCControlProgressEndDragSlider]) {
            [strongself showControlThenHide];
        }

        if (strongself.eventCallBack) {
            strongself.eventCallBack(action, value);
        }
        return nil;
    };

    self.eventCallBack = ^id(NSString *action, id value) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([action isEqualToString:kMCPlayer2PlayAction]) {
            [strongSelf.playerKit play];
        } else if ([action isEqualToString:kMCPlayer2PauseAction]) {
            [strongSelf.playerKit pause];
        } else if ([action isEqualToString:kMCTouchCurrentTimeAction]) {
            return @(strongSelf.playerKit.currentTime);
        } else if ([action isEqualToString:kMCTouchDurationAction]) {
            return @(strongSelf.playerKit.duration);
        } else if ([action isEqualToString:kMCTouchSeekAction]) {
            [strongSelf.playerKit seekSeconds:[value integerValue]];
        }
        return nil;
    };
}

- (void)fadeHiddenControl {
    [self.topView fadeHiddenControl];
    [self.bottomView fadeHiddenControl];
    self.lockBtn.hidden = YES;
    self.playBtn.hidden = YES;
    self.bottomProgress.hidden = NO;
}

- (void)showControl {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeHiddenControl) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self.lockBtn selector:@selector(setHidden:) object:@(YES)];
    [self.topView showControl];
    [self.bottomView showControl];
    self.bottomProgress.hidden = YES;
    if (self.styleSizeType == PlayerStyleSizeClassRegularHalf) {
        self.playBtn.hidden = self.bottomView.hidden;
    } else {
        self.lockBtn.hidden = self.bottomView.hidden;
    }
}

- (void)showControlThenHide {
    if ([self isLock]) {
        self.lockBtn.hidden = NO;
        [self.lockBtn performSelector:@selector(setHidden:) withObject:@(YES) afterDelay:3];
    } else {
        [self showControl];
        [self performSelector:@selector(fadeHiddenControl) withObject:nil afterDelay:3];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addLayout];
}

#pragma mark Actions

- (void)lockBtnClick {
    self.lockBtn.selected = !self.lockBtn.selected;
    if (self.lockBtn.selected) {
        [self fadeHiddenControl];
    } else {
        [self showControlThenHide];
    }
}

- (void)playBtnClick {
    self.playBtn.selected = !self.playBtn.selected;
    self.bottomView.playBtn.selected = self.playBtn.selected;
    if (self.playBtn.selected) {
        [self.playerKit pause];
    } else {
        [self.playerKit play];
    }
}

#pragma mark - MCPlayerDelegate

- (void)playLoading {
    [self.loadingView startRotating];
}

- (void)playBuffer {
    [self.loadingView startRotatingNoBg];
}

- (void)playStart {
    [self.loadingView endRotating];
    [self showControlThenHide];
    [self duration:self.playerKit.duration];
}

- (void)playPlay {

}

- (void)playEnd {

}

- (void)playError {
    [self.loadingView endRotating];
    //TODO:: error
}

- (void)updatePlayView {

}

#pragma mark - getter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
    }
    return _containerView;
}

- (MCPlayerGeneralTouchView *)touchView {
    if (!_touchView) {
        _touchView = [MCPlayerGeneralTouchView new];
    }
    return _touchView;
}

- (MCPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [MCPlayerView new];
        _playerView.userInteractionEnabled = NO;
    }
    return _playerView;
}

- (MCPlayerGeneralHeader *)topView {
    if (!_topView) {
        _topView = [MCPlayerGeneralHeader new];
    }
    return _topView;
}

- (MCPlayerGeneralFooter *)bottomView {
    if (!_bottomView) {
        _bottomView = [MCPlayerGeneralFooter new];
    }
    return _bottomView;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [UIButton new];
        [_lockBtn setImage:[MCStyle customImage:@"player_body_0"] forState:UIControlStateNormal];
        [_lockBtn setImage:[MCStyle customImage:@"player_body_0_s"] forState:UIControlStateSelected];
        [_lockBtn addTarget:self action:@selector(lockBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _lockBtn.hidden = YES;
    }
    return _lockBtn;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton new];
        [_playBtn setImage:[MCStyle customImage:@"player_body_1"] forState:UIControlStateNormal];
        [_playBtn setImage:[MCStyle customImage:@"player_body_1_s"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIView *)definitionView {
    return nil;
}

- (MCPlayerLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [MCPlayerLoadingView new];
    }
    return _loadingView;
}

- (MCPlayerProgress *)bottomProgress {
    if (!_bottomProgress) {
        _bottomProgress = [MCPlayerProgress new];
        [_bottomProgress changeSliderStyle:SliderShowProgress];
        _bottomProgress.hidden = YES;
    }
    return _bottomProgress;
}

@end


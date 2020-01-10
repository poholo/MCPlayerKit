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
#import "MCDeviceUtils.h"
#import "MCPlayerGeneralTerminalView.h"
#import "MCPlayerKitDef.h"

NSString *const kMCPlayerDestory = @"kMCPlayerDestory";

@interface MCPlayerGeneralView () <MCPlayerDelegate, MCPlayerTerminalDelegate>

@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) MCPlayerGeneralTouchView *touchView;
@property(nonatomic, strong) MCPlayerView *playerView;
@property(nonatomic, strong) MCPlayerLoadingView *loadingView;

@property(nonatomic, strong) MCPlayerGeneralHeader *topView;
@property(nonatomic, strong) MCPlayerGeneralFooter *bottomView;
@property(nonatomic, strong) MCPlayerProgress *bottomProgress;
@property(nonatomic, strong) MCPlayerGeneralTerminalView *terminalView;
@property(nonatomic, strong) UIButton *lockBtn;
@property(nonatomic, strong) UIButton *playBtn;
@property(nonatomic, strong) UIButton *backBtn;

@property(nonatomic, weak) MCPlayerKit *playerKit;


@property(nonatomic, copy) MCPlayerNormalViewEventCallBack eventCallBack;

@end

@implementation MCPlayerGeneralView

- (void)dealloc {
    [self freeSpace];
    MCLog(@"[PK]%@ dealloc", NSStringFromClass(self.class));
}

- (void)freeSpace {
    if (_playerKit) {
        [_playerKit removeDelegate:self];
        [_playerKit destory];
        _playerKit = nil;
    }
    if (_touchView) {
        [_touchView removeFromSuperview];
        _touchView.callBack = nil;
        _touchView = nil;
    }
    if (_playerView) {
        [_playerView removeFromSuperview];
        _playerView = nil;
    }
    if (_loadingView) {
        [_loadingView removeFromSuperview];
        _loadingView = nil;
    }
    if (_topView) {
        [_topView removeFromSuperview];
        _topView.callBack = nil;
        _topView = nil;
    }

    if (_bottomView) {
        [_bottomView removeFromSuperview];
        _bottomView.callBack = nil;
        _bottomView = nil;
    }

    if (_terminalView) {
        [_terminalView removeFromSuperview];
        _terminalView.delegate = nil;
        _terminalView = nil;
    }

    self.eventCallBack = nil;
    self.retryPlayUrl = nil;
    self.canShowTerminalCallBack = nil;
    [self removeFromSuperview];
}

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
        case MCPlayerStyleSizeClassRegularHalf: {
            self.backBtn.hidden = NO;
            self.lockBtn.hidden = YES;
            self.playBtn.hidden = self.bottomView.hidden;
        }
            break;
        case MCPlayerStyleSizeClassRegular: {
            self.backBtn.hidden = YES;
            self.lockBtn.hidden = self.bottomView.hidden;
            self.playBtn.hidden = YES;
        }
            break;
        case MCPlayerStyleSizeClassCompact: {
            self.backBtn.hidden = YES;
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

- (void)updateAction:(__weak MCPlayerKit *)playerKit {
    self.playerKit = playerKit;
    [self.playerKit addDelegate:self];
}

- (void)updatePlayerPicture:(NSString *)url {
    [self.loadingView updatePlayerPicture:url];
}

#pragma mark -

- (void)rotate2Landscape {
    if (self.styleSizeType == MCPlayerStyleSizeClassCompact) {
        return;
    }
    [MCRotateHelper setStatusBarHidden:YES];

    [self updatePlayerStyle:MCPlayerStyleSizeClassCompact];
    self.frame = [UIScreen mainScreen].bounds;
}

- (void)rotate2Portrait {
    if (self.styleSizeType == MCPlayerStyleSizeClassRegularHalf) {
        return;
    }
    [MCRotateHelper setStatusBarHidden:NO];
    CGSize size = [UIScreen mainScreen].bounds.size;
    [self updatePlayerStyle:MCPlayerStyleSizeClassRegularHalf];
    self.frame = CGRectMake(0, 0, size.width, size.width * 9 / 16 + [MCDeviceUtils xStatusBarHeight]);
}

- (void)rotate2PortraitFullScreen {
    if (self.styleSizeType == MCPlayerStyleSizeClassRegular) {
        return;
    }
    [MCRotateHelper setStatusBarHidden:YES];
    [self updatePlayerStyle:MCPlayerStyleSizeClassRegular];
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

    [self.containerView addSubview:self.loadingView];
    [self.containerView addSubview:self.terminalView];
    [self.containerView addSubview:self.backBtn];
    self.backgroundColor = [UIColor blackColor];
}

- (void)addLayout {
    if (CGRectIsEmpty(self.frame)) return;

    CGRect containerFrame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    if (self.styleSizeType == MCPlayerStyleSizeClassCompact) {
        containerFrame = CGRectMake([MCDeviceUtils xTop], 0, CGRectGetWidth(self.frame) - [MCDeviceUtils xTop] * 2, CGRectGetHeight(self.frame));
    }
    self.containerView.frame = containerFrame;
    self.touchView.frame = self.containerView.bounds;
    self.terminalView.frame = self.containerView.bounds;

    CGFloat w = CGRectGetWidth(self.containerView.frame);
    CGFloat h = CGRectGetHeight(self.containerView.frame);
    CGFloat barRate = 0.1f;
    CGFloat barHeight = 44;

    if (self.styleSizeType == MCPlayerStyleSizeClassRegularHalf || self.styleSizeType == MCPlayerStyleSizeClassRegular) {
        CGFloat py = [MCDeviceUtils iPhoneX] ? 24 : 0;
        self.playerView.frame = CGRectMake(0, py, CGRectGetWidth(containerFrame), CGRectGetHeight(containerFrame) - py);
        self.topView.frame = CGRectMake(0, 0, w, barHeight + [MCDeviceUtils xStatusBarHeight]);
    } else {
        self.playerView.frame = self.containerView.bounds;
        self.topView.frame = CGRectMake(0, 0, w, barHeight);
    }

    self.bottomView.frame = CGRectMake(0, h - barHeight, w, barHeight);
    if (self.styleSizeType == MCPlayerStyleSizeClassRegular || self.styleSizeType == MCPlayerStyleSizeClassCompact) {
        self.bottomView.frame = CGRectMake(0, h - barHeight - [MCDeviceUtils xBottom], w, barHeight + [MCDeviceUtils xBottom]);
    }
    self.bottomProgress.frame = CGRectMake(0, h - 2, w, 2);

    CGFloat lockW = 44;
    self.lockBtn.frame = CGRectMake(10, (h - lockW) / 2.0f, lockW, lockW);
    CGFloat playW = 44;
    self.playBtn.frame = CGRectMake((CGRectGetWidth(self.frame) - playW) / 2.0f, (CGRectGetHeight(self.frame) - playW) / 2.0f, playW, playW);
    self.loadingView.frame = self.containerView.bounds;
    self.backBtn.frame = CGRectMake(0, [MCDeviceUtils xStatusBarHeight], lockW, lockW);
}

- (void)addActions {
    __weak typeof(self) weakSelf = self;
    self.topView.callBack = ^id(NSString *action, id value) {
        __strong typeof(weakSelf) strongself = weakSelf;
        if ([action isEqualToString:kMCPlayerHeaderBack]) {
            [strongself backBtnClick];
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
            [strongself rotate2Portrait];
            [strongself showControlThenHide];
        } else if ([action isEqualToString:kMCPlayer2FullScreenAction]) {
            CGSize naturalSize = strongself.playerKit.naturalSize;
            if (naturalSize.width < naturalSize.height) {
                [MCRotateHelper updatePlayerRegular];
                [strongself rotate2PortraitFullScreen];
            } else {
                [MCRotateHelper updatePlayerCompact];
                [strongself rotate2Landscape];
            }
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
    if (self.styleSizeType == MCPlayerStyleSizeClassRegularHalf) {
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

- (void)backBtnClick {
    if (self.styleSizeType != MCPlayerStyleSizeClassRegularHalf) {
        [MCRotateHelper updatePlayerRegularHalf];
        [self rotate2Portrait];
    } else {
        UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *navigationController;
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            navigationController = (UINavigationController *) viewController;
            if ([navigationController.topViewController isKindOfClass:[UITabBarController class]]) {
                UITabBarController *tabBarController = (UITabBarController *) navigationController.topViewController;
                UIViewController *tabViewController = (tabBarController.viewControllers.count > tabBarController.selectedIndex ? tabBarController.viewControllers[tabBarController.selectedIndex] : nil);
                if ([tabViewController isKindOfClass:[UINavigationController class]]) {
                    navigationController = (UINavigationController *) tabViewController;
                }
            }
        } else if (viewController.navigationController) {
            navigationController = viewController.navigationController;
        }
        if (self.outEventCallBack) {
            self.outEventCallBack(kMCPlayerDestory, nil);
        }
        [self freeSpace];
        if (navigationController) {
            [navigationController popViewControllerAnimated:YES];
        } else {
            [viewController dismissViewControllerAnimated:YES completion:NULL];
        }
    }
}

#pragma mark - MCPlayerDelegate

- (void)playLoading {
    [self.loadingView startRotating];
    self.terminalView.hidden = YES;
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
    if (self.canShowTerminalCallBack) {
        BOOL can = self.canShowTerminalCallBack();
        if (can) {
            [self.terminalView updatePlayerTerminal:MCPlayerTerminalPlayEnd title:self.topView.titleLabel.text];
            self.terminalView.hidden = NO;
        }
    } else {
        [self.terminalView updatePlayerTerminal:MCPlayerTerminalPlayEnd title:self.topView.titleLabel.text];
        self.terminalView.hidden = NO;
    }
}

- (void)playError {
    [self.loadingView endRotating];
    [self.terminalView updatePlayerTerminal:MCPlayerTerminalError title:self.topView.titleLabel.text];
    self.terminalView.hidden = NO;
}

- (void)updatePlayView {

}

#pragma mark - PlayerTerminalDelegate

- (void)retryPlay {
    if (!self.retryPlayUrl) return;

    NSString *url = self.retryPlayUrl();

    if (!url) return;
    [self.playerKit playUrls:@[url]];
}

- (void)terminalPlayEndReplay {
    [self retryPlay];
}

- (void)terminal3GCanContinuePlay {
}

- (void)terminalNetErrorRetry {
    [self retryPlay];
}

- (void)terminalUrlErrorRetry {
    [self retryPlay];
}

- (void)terminalErrorRetry {
    [self retryPlay];
}

- (void)terminalShowAirplay2Pause {

}

- (void)terminalQuitAirplay2Play {

}

- (void)terminalAirplayPlay {

}

- (void)terminalAirplayPause {

}

- (void)terminalAirplayVolumeLarge {

}

- (void)terminalAirplayVolumeSmall {

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

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[MCStyle customImage:@"player_header_0"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
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
        [_bottomProgress changeSliderStyle:MCSliderShowProgress];
        _bottomProgress.hidden = YES;
    }
    return _bottomProgress;
}

- (MCPlayerGeneralTerminalView *)terminalView {
    if (!_terminalView) {
        _terminalView = [MCPlayerGeneralTerminalView new];
        _terminalView.delegate = self;
        _terminalView.hidden = YES;
    }
    return _terminalView;
}


- (void)setUnableSeek:(BOOL)unableSeek {
    _unableSeek = unableSeek;
    self.unableSeek = unableSeek;
    self.bottomView.unableSeek = unableSeek;
}

@end


//
// Created by majiancheng on 2017/3/17.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "MCPlayerNormalView.h"

#import <MCStyle/MCStyleDef.h>

#import "MCPlayerNormalHeader.h"
#import "MCPlayerNormalFooter.h"
#import "MCPlayerNormalTouchView.h"
#import "MCRotateHelper.h"

@interface MCPlayerNormalView ()

@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) MCPlayerNormalTouchView *touchView;
@property(nonatomic, strong) MCPlayerBaseView *playerView;
@property(nonatomic, strong) UIImageView *coverImageView;
@property(nonatomic, strong) UIView *loadingView;

@property(nonatomic, strong) MCPlayerNormalHeader *topView;
@property(nonatomic, strong) MCPlayerNormalFooter *bottomView;
@property(nonatomic, strong) UIButton *lockBtn;
@property(nonatomic, strong) UIView *definitionView;


@end

@implementation MCPlayerNormalView

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
}

- (void)updatePlayerStyle:(MCPlayerStyleSizeType)styleSizeType {
    if (self.styleSizeType == styleSizeType) return;
    self.styleSizeType = styleSizeType;
    [self.topView updatePlayerStyle:styleSizeType];
    [self.bottomView updatePlayerStyle:styleSizeType];
    switch (self.styleSizeType) {
        case PlayerStyleSizeClassRegularHalf: {
        }
            break;
        case PlayerStyleSizeClassRegular: {

        }
            break;
        case PlayerStyleSizeClassCompact: {

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


#pragma mark - views

- (void)createViews {
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.touchView];
    [self.containerView addSubview:self.playerView];
    [self.containerView addSubview:self.topView];
    [self.containerView addSubview:self.bottomView];
    [self.containerView addSubview:self.lockBtn];
    [self.containerView addSubview:self.definitionView];

    [self.containerView addSubview:self.coverImageView];
    [self.containerView addSubview:self.loadingView];

    self.topView.backgroundColor = [MCColor randomImageColor];
    self.bottomView.backgroundColor = [MCColor randomImageColor];
    self.topView.titleLabel.text = @"Skipping code signing because the target does not have an Info.plist file. (in target 'App')";
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

    CGFloat lockW = 44;
    self.lockBtn.frame = CGRectMake(10, (h - lockW) / 2.0f, lockW, lockW);
    self.coverImageView.frame = self.containerView.bounds;
}

- (void)addActions {
    __weak typeof(self) weakSelf = self;
    self.topView.callBack = ^(NSString *action, id value) {
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
    };

    self.touchView.callBack = ^(NSString *action, id value) {
        __strong typeof(weakSelf) strongself = weakSelf;
        if ([action isEqualToString:kMCTouchTapAction]) {
            [strongself showControl];
        }
        if (strongself.eventCallBack) {
            strongself.eventCallBack(action, value);
        }
    };

    self.bottomView.callBack = ^(NSString *action, id value) {
        __strong typeof(weakSelf) strongself = weakSelf;
        if ([action isEqualToString:kMCPlayer2HalfScreenAction]) {
            [MCRotateHelper updatePlayerRegularHalf];
            [strongself updatePlayerStyle:PlayerStyleSizeClassRegularHalf];
        } else if ([action isEqualToString:kMCPlayer2FullScreenAction]) {
            //TODO:: 竖屏全屏
            [MCRotateHelper updatePlayerRegular];
            [strongself updatePlayerStyle:PlayerStyleSizeClassCompact];
        }

        if (strongself.eventCallBack) {
            strongself.eventCallBack(action, value);
        }
    };
}

- (void)fadeHiddenControl {
    [self.topView fadeHiddenControl];
    [self.bottomView fadeHiddenControl];
    self.lockBtn.hidden = YES;
}

- (void)showControl {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeHiddenControl) object:nil];
    [self.topView showControl];
    [self.bottomView showControl];
    self.lockBtn.hidden = NO;
    [self performSelector:@selector(fadeHiddenControl) withObject:nil afterDelay:3];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addLayout];
}

#pragma mark Actions

- (void)lockBtnClick {
    self.lockBtn.selected = !self.lockBtn.selected;
    //TODO:: lock
}

#pragma mark - getter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
    }
    return _containerView;
}

- (MCPlayerNormalTouchView *)touchView {
    if (!_touchView) {
        _touchView = [MCPlayerNormalTouchView new];
    }
    return _touchView;
}

- (MCPlayerBaseView *)playerView {
    if (!_playerView) {
        _playerView = [MCPlayerBaseView new];
        _playerView.userInteractionEnabled = NO;
    }
    return _playerView;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
    }
    return _coverImageView;
}

- (MCPlayerNormalHeader *)topView {
    if (!_topView) {
        _topView = [MCPlayerNormalHeader new];
    }
    return _topView;
}

- (MCPlayerNormalFooter *)bottomView {
    if (!_bottomView) {
        _bottomView = [MCPlayerNormalFooter new];
    }
    return _bottomView;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [UIButton new];
        [_lockBtn setImage:[MCStyle customImage:@"player_body_0"] forState:UIControlStateNormal];
        [_lockBtn setImage:[MCStyle customImage:@"player_body_0_s"] forState:UIControlStateSelected];
        [_lockBtn addTarget:self action:@selector(lockBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lockBtn;
}

- (UIView *)definitionView {
    return nil;
}

@end


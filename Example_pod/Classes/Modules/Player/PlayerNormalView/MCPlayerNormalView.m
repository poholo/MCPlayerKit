//
// Created by majiancheng on 2017/3/17.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "MCPlayerNormalView.h"

#import "MCPlayerNormalHeader.h"
#import "MCPlayerNormalFooter.h"
#import "MCPlayerNormalTouchView.h"

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

@property(nonatomic, assign) MCPlayerStyleSizeType styleSizeType;

@end

@implementation MCPlayerNormalView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createViews];
        [self addLayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self createViews];
        [self addLayout];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self createViews];
        [self addLayout];
    }
    return self;
}

- (void)updatePlayerStyle:(MCPlayerStyleSizeType)styleSizeType {
    if (self.styleSizeType == styleSizeType) return;
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
}

- (void)addLayout {
    if (CGRectIsEmpty(self.frame)) return;
    self.containerView.frame = self.bounds;
    //TODO:: 2018 devices
    self.touchView.frame = self.containerView.bounds;
    self.playerView.frame = self.containerView.bounds;
    CGFloat w = CGRectGetWidth(self.containerView.frame);
    CGFloat h = CGRectGetHeight(self.containerView.frame);
    CGFloat barRate = 0.2f;
    CGFloat barHeight = barRate * h;
    self.topView.frame = CGRectMake(0, 0, w, h);
    self.bottomView.frame = CGRectMake(0, h - barHeight, w, barHeight);

    CGFloat lockW = 44;
    self.lockBtn.frame = CGRectMake(10, (h - lockW) / 2.0f, lockW, lockW);
    self.coverImageView.frame = self.containerView.bounds;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addLayout];
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
    if(!_topView) {
        _topView = [MCPlayerNormalHeader new];
    }
    return _topView;
}

- (MCPlayerNormalFooter *)bottomView {
    if(!_bottomView) {
        _bottomView = [MCPlayerNormalFooter new];
    }
    return _bottomView;
}

- (UIButton *)lockBtn {
    if(!_lockBtn) {
        _lockBtn = [UIButton new];
        [_lockBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    return _lockBtn;
}

- (UIView *)definitionView {
    return nil;
}


@end

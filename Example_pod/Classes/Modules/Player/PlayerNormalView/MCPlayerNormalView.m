//
// Created by majiancheng on 2017/3/17.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "MCPlayerNormalView.h"
#import "MCPlayerNormalHeader.h"
#import "MCPlayerNormalFooter.h"

@interface MCPlayerNormalView ()

@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) UIView *touchView;
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

}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addLayout];
}


#pragma mark - getter

- (UIView *)containerView {
    if(!_containerView) {
        _containerView = [UIView new];
    }
    return _containerView;
}

- (UIView *)touchView {
    if(!_touchView) {
        _touchView = [UIView new];
    }
    return _touchView;
}

- (MCPlayerBaseView *)playerView {
    if(!_playerView) {
        _playerView = [MCPlayerBaseView new];
    }
    return _playerView;
}

- (UIImageView *)coverImageView {
    if(!_coverImageView) {
        _coverImageView = [UIImageView new];
    }
    return _coverImageView;
}

- (MCPlayerNormalHeader *)topView {
    return nil;
}

- (MCPlayerNormalFooter *)bottomView {
    return nil;
}

- (UIButton *)lockBtn {
    return nil;
}

- (UIView *)definitionView {
    return nil;
}


@end

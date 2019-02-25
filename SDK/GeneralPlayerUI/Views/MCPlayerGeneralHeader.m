//
// Created by majiancheng on 2018/12/28.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "MCPlayerGeneralHeader.h"
#import "MCDeviceUtils.h"
#import "MCCustomActionView.h"

#import <MCStyle/MCStyleDef.h>

NSString *const kMCPlayerHeaderBack = @"kMCPlayerHeaderBack";

@interface MCPlayerGeneralHeader ()

@property(nonatomic, strong) CAGradientLayer *gradientLayer;
@property(nonatomic, strong) UIButton *backBtn;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) MCCustomActionView *rightView;

@property(nonatomic, assign) MCPlayerStyleSizeType styleSizeType;

@end


@implementation MCPlayerGeneralHeader

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createViews];
        [self addLayout];
    }
    return self;
}

- (void)updatePlayerStyle:(MCPlayerStyleSizeType)styleSizeType {
    self.styleSizeType = styleSizeType;
    [self.rightView updatePlayerStyle:styleSizeType];
    switch (styleSizeType) {
        case MCPlayerStyleSizeClassRegularHalf: {
        }
            break;
        case MCPlayerStyleSizeClassRegular: {
        }
            break;
        case MCPlayerStyleSizeClassCompact: {
        }
            break;
    }
}

- (void)backBtnClick {
    if (!self.callBack) return;
    self.callBack(kMCPlayerHeaderBack, nil);
}

- (void)createViews {
    [self.layer addSublayer:self.gradientLayer];
    [self addSubview:self.backBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.rightView];
}

- (void)addLayout {
    if (CGRectIsEmpty(self.frame))
        return;
    UIEdgeInsets insets = [MCStyle contentInsetII];
    CGFloat top = (self.styleSizeType == MCPlayerStyleSizeClassRegularHalf || self.styleSizeType == MCPlayerStyleSizeClassRegular) ? [MCDeviceUtils xStatusBarHeight] : 0;
    CGFloat h = CGRectGetHeight(self.frame) - top;
    CGFloat w = h - 2 * insets.top;
    self.backBtn.frame = CGRectMake(0, top, h, h);
    [self.rightView resizeViews];
    self.rightView.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.rightView.frame), top, CGRectGetWidth(self.rightView.frame), h);
    CGFloat startX = CGRectGetMaxX(self.backBtn.frame) - [MCStyle contentInsetIII].left;
    CGFloat maxTitleWidth = CGRectGetMinX(self.rightView.frame) - startX - [MCStyle contentInsetIII].right;
    self.titleLabel.frame = CGRectMake(startX, (h - [MCFont fontV].lineHeight) / 2.0f + top, maxTitleWidth, [MCFont fontV].lineHeight);
    self.gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (void)fadeHiddenControl {
    self.hidden = YES;
}

- (void)showControl {
    self.hidden = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addLayout];
}

#pragma mark -getter

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[MCStyle customImage:@"player_header_0"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [MCFont fontIV];
        _titleLabel.textColor = [MCColor colorI];
    }
    return _titleLabel;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(__bridge id) [MCColor rgba:0x00000099].CGColor, (__bridge id) [MCColor rgba:0x0000005].CGColor];
        _gradientLayer.locations = @[@(.4)];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1.0);
        _gradientLayer.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame), 50);
    }
    return _gradientLayer;
}

- (MCCustomActionView *)rightView {
    if (!_rightView) {
        _rightView = [MCCustomActionView new];
    }
    return _rightView;
}
@end

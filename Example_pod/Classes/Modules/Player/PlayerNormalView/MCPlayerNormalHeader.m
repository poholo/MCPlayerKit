//
// Created by majiancheng on 2018/12/28.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "MCPlayerNormalHeader.h"

#import <MCStyle/MCStyleDef.h>

@interface MCPlayerNormalHeader ()

@property(nonatomic, strong) UIButton *backBtn;
@property(nonatomic, strong) UILabel *titleLabel;

@end


@implementation MCPlayerNormalHeader

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createViews];
        [self addLayout];
    }
    return self;
}


- (void)createViews {
    [self addSubview:self.backBtn];
    [self addSubview:self.titleLabel];
}

- (void)addLayout {
    if (CGRectIsEmpty(self.frame))
        return;
    UIEdgeInsets insets = [MCStyle contentInsetII];
    CGFloat w = CGRectGetHeight(self.frame) - 2 * insets.top;
    self.backBtn.frame = CGRectMake(insets.left, insets.top, w, w);

    CGFloat startX = CGRectGetMaxX(self.backBtn.frame) - [MCStyle contentInsetIII].left;
    CGFloat maxTitleWidth = CGRectGetWidth(self.frame) - startX - [MCStyle contentInsetIII].right;
    self.titleLabel.frame = CGRectMake(startX, (CGRectGetHeight(self.frame) - [MCFont fontV].lineHeight) / 2.0f, maxTitleWidth, [MCFont fontV].lineHeight);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addLayout];
}

#pragma mark -getter

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[MCStyle imageI] forState:UIControlStateNormal];
        [_backBtn setImage:[MCStyle imageI_s] forState:UIControlStateHighlighted];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [MCFont fontV];
        _titleLabel.textColor = [MCColor colorII];
    }
    return _titleLabel;
}

@end
//
// Created by majiancheng on 2018/12/28.
// Copyright (c) 2018 majiancheng. All rights reserved.
//


#import "MCPlayerNormalFooter.h"

#import <MCStyleDef.h>

#import "MCPlayerProgress.h"
#import "NSNumber+Extend.h"

NSString *const kMCPlayer2HalfScreenAction = @"kMCPlayer2HalfScreenAction";
NSString *const kMCPlayer2FullScreenAction = @"kMCPlayer2FullScreenAction";
NSString *const kMCPlayer2PlayAction = @"kMCPlayer2PlayAction";
NSString *const kMCPlayer2PauseAction = @"kMCPlayer2PauseAction";

@interface MCPlayerNormalFooter ()

@property(nonatomic, strong) UIButton *playBtn;
@property(nonatomic, strong) UILabel *durationLabel;
@property(nonatomic, strong) UILabel *currentLabel;
@property(nonatomic, strong) MCPlayerProgress *playerProgress;
@property(nonatomic, strong) UIButton *screenBtn;

@end

@implementation MCPlayerNormalFooter

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createViews];
        [self addLayout];
    }
    return self;
}

- (void)playBtnClick {
    if (self.callBack) {
        self.callBack(self.playBtn.selected ? kMCPlayer2PlayAction : kMCPlayer2PauseAction, nil);
    }
    self.playBtn.selected = !self.playBtn.selected;
}

- (void)screenBtnClick {
    if (self.callBack) {
        self.callBack(self.screenBtn.selected ? kMCPlayer2HalfScreenAction : kMCPlayer2FullScreenAction, nil);
    }
}

- (void)updatePlayerStyle:(MCPlayerStyleSizeType)styleSizeType {
    switch (styleSizeType) {
        case PlayerStyleSizeClassRegularHalf: {
            self.screenBtn.selected = NO;
        }
            break;
        case PlayerStyleSizeClassRegular: {
            self.screenBtn.selected = YES;
        }
            break;
        case PlayerStyleSizeClassCompact: {
            self.screenBtn.selected = YES;
        }
            break;
    }
}

- (void)currentTime:(double)time {
    self.currentLabel.text = [@(time) hhMMss];
    [self refreshTimeFrame];
}

- (void)duration:(double)time {
    self.durationLabel.text = [@(time) hhMMss];
    [self refreshTimeFrame];
}

- (void)updateProgress:(float)progress {
    [self.playerProgress updateProgress:progress];
}

- (void)updateBufferProgress:(float)progress {
    [self.playerProgress updateBufferProgress:progress];
}


- (void)createViews {
    [self addSubview:self.playBtn];
    [self addSubview:self.currentLabel];
    [self addSubview:self.durationLabel];
    [self addSubview:self.playerProgress];
    [self addSubview:self.screenBtn];
}

- (void)addLayout {
    if (CGRectIsEmpty(self.frame)) return;

    CGFloat w = CGRectGetHeight(self.frame) - 2 * [MCStyle contentInsetII].top;
    self.playBtn.frame = CGRectMake([MCStyle contentInsetII].left, [MCStyle contentInsetII].top, w, w);
    self.screenBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - w - [MCStyle contentInsetII].right, [MCStyle contentInsetII].top, w, w);
    [self refreshTimeFrame];
}

- (void)refreshTimeFrame {
    if (CGRectIsEmpty(self.frame)) return;

    CGSize durationSize = [self.durationLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame) * .5f, self.durationLabel.font.lineHeight)];
    self.durationLabel.frame = CGRectMake(CGRectGetMinX(self.screenBtn.frame) - durationSize.width - [MCStyle contentInsetII].right,
            (CGRectGetHeight(self.frame) - self.durationLabel.font.lineHeight) / 2.0f,
            durationSize.width,
            self.durationLabel.font.lineHeight);

    CGSize currentSize = [self.currentLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame) * .5f, self.currentLabel.font.lineHeight)];
    self.currentLabel.frame = CGRectMake(CGRectGetMaxX(self.playBtn.frame) + [MCStyle contentInsetIII].left,
            (CGRectGetHeight(self.frame) - self.currentLabel.font.lineHeight) / 2.0f,
            currentSize.width,
            self.currentLabel.font.lineHeight);


    self.playerProgress.frame = CGRectMake(CGRectGetMaxX(self.currentLabel.frame) + [MCStyle contentInsetII].left,
            CGRectGetHeight(self.frame) * 0.25,
            CGRectGetMinX(self.durationLabel.frame) - CGRectGetMaxX(self.currentLabel.frame) - [MCStyle contentInsetII].right - [MCStyle contentInsetII].left,
            CGRectGetHeight(self.frame) * 0.5f);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addLayout];
}

#pragma mark - getter

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton new];
        [_playBtn setImage:[MCStyle customImage:@"player_footer_0"] forState:UIControlStateNormal];
        [_playBtn setImage:[MCStyle customImage:@"player_footer_0_s"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [UILabel new];
        _durationLabel.font = [MCFont fontV];
        _durationLabel.textColor = [MCColor colorIII];
    }
    return _durationLabel;
}

- (UILabel *)currentLabel {
    if (!_currentLabel) {
        _currentLabel = [UILabel new];
        _currentLabel.font = [MCFont fontV];
        _currentLabel.textColor = [MCColor colorIII];
    }
    return _currentLabel;
}

- (MCPlayerProgress *)playerProgress {
    if (!_playerProgress) {
        _playerProgress = [MCPlayerProgress new];
    }
    return _playerProgress;
}

- (UIButton *)screenBtn {
    if (!_screenBtn) {
        _screenBtn = [UIButton new];
        [_screenBtn setImage:[MCStyle customImage:@"player_footer_1"] forState:UIControlStateNormal];
        [_screenBtn setImage:[MCStyle customImage:@"player_footer_1_s"] forState:UIControlStateSelected];
        [_screenBtn addTarget:self action:@selector(screenBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _screenBtn;
}

@end
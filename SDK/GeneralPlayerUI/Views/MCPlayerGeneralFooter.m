//
// Created by majiancheng on 2018/12/28.
// Copyright (c) 2018 majiancheng. All rights reserved.
//


#import "MCPlayerGeneralFooter.h"

#import <MCStyleDef.h>

#import "MCPlayerProgress.h"
#import "NSNumber+MCExtend.h"
#import "MCCustomActionView.h"
#import "MCPlayerKitDef.h"

NSString *const kMCPlayer2HalfScreenAction = @"kMCPlayer2HalfScreenAction";
NSString *const kMCPlayer2FullScreenAction = @"kMCPlayer2FullScreenAction";
NSString *const kMCPlayer2PlayAction = @"kMCPlayer2PlayAction";
NSString *const kMCPlayer2PauseAction = @"kMCPlayer2PauseAction";
NSString *const kMCControlProgressStartDragSlider = @"kMCControlProgressStartDragSlider";
NSString *const kMCDragProgressToProgress = @"kMCDragProgressToProgress";
NSString *const kMCControlProgressEndDragSlider = @"kMCControlProgressEndDragSlider";

@interface MCPlayerGeneralFooter () <MCPlayerProgressDelegate>

@property(nonatomic, strong) CAGradientLayer *gradientLayer;

@property(nonatomic, strong) UIButton *playBtn;
@property(nonatomic, strong) UILabel *durationLabel;
@property(nonatomic, strong) UILabel *currentLabel;
@property(nonatomic, strong) MCPlayerProgress *playerProgress;
@property(nonatomic, strong) MCCustomActionView *rightView;
@property(nonatomic, strong) UIButton *screenBtn;
@property(nonatomic, assign) MCPlayerStyleSizeType styleSizeType;

@end

@implementation MCPlayerGeneralFooter
- (void)dealloc {
    MCLog(@"[PK]%@ dealloc", NSStringFromClass(self.class));
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createViews];
        [self addLayout];
    }
    return self;
}

- (void)playBtnClick {
    self.playBtn.selected = !self.playBtn.selected;
    if (self.callBack) {
        self.callBack(self.playBtn.selected ? kMCPlayer2PauseAction : kMCPlayer2PlayAction, nil);
    }
}

- (void)screenBtnClick {
    if (self.callBack) {
        self.callBack(self.screenBtn.selected ? kMCPlayer2HalfScreenAction : kMCPlayer2FullScreenAction, nil);
    }
}

- (void)updatePlayerStyle:(MCPlayerStyleSizeType)styleSizeType {
    self.styleSizeType = styleSizeType;
    [self.rightView updatePlayerStyle:styleSizeType];
    switch (styleSizeType) {
        case MCPlayerStyleSizeClassRegularHalf: {
            self.screenBtn.selected = NO;
            self.playBtn.hidden = YES;
        }
            break;
        case MCPlayerStyleSizeClassRegular: {
            self.screenBtn.selected = YES;
            self.playBtn.hidden = NO;
        }
            break;
        case MCPlayerStyleSizeClassCompact: {
            self.screenBtn.selected = YES;
            self.playBtn.hidden = NO;
        }
            break;
    }
}

- (void)currentTime:(double)time {
    NSString *t = [@(time) hhMMss];
    if (self.styleSizeType == MCPlayerStyleSizeClassRegularHalf) {
        t = [t stringByAppendingString:@"/"];
    }
    self.currentLabel.text = t;
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

- (void)fadeHiddenControl {
    self.hidden = YES;
}

- (void)showControl {
    self.hidden = NO;
}

- (void)createViews {
    [self.layer addSublayer:self.gradientLayer];
    [self addSubview:self.playBtn];
    [self addSubview:self.currentLabel];
    [self addSubview:self.durationLabel];
    [self addSubview:self.playerProgress];
    [self addSubview:self.rightView];
    [self addSubview:self.screenBtn];
}

- (void)addLayout {
    if (CGRectIsEmpty(self.frame)) return;

    CGFloat w = CGRectGetHeight(self.frame) - 2 * [MCStyle contentInsetII].top;
    self.playBtn.frame = CGRectMake([MCStyle contentInsetII].left, [MCStyle contentInsetII].top, w, w);

    self.screenBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - w - [MCStyle contentInsetII].right, [MCStyle contentInsetII].top, w, w);

    [self.rightView resizeViews];
    self.rightView.frame = CGRectMake(CGRectGetMinX(self.screenBtn.frame) - CGRectGetWidth(self.rightView.frame), [MCStyle contentInsetII].top, CGRectGetWidth(self.rightView.frame), w);

    self.gradientLayer.frame = self.bounds;
    [self refreshTimeFrame];
}

- (void)refreshTimeFrame {
    if (CGRectIsEmpty(self.frame)) return;
    CGSize durationSize = [self.durationLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame) * .5f, self.durationLabel.font.lineHeight)];
    CGSize currentSize = [self.currentLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame) * .5f, self.currentLabel.font.lineHeight)];
    CGFloat durationX = CGRectGetMinX(self.rightView.frame) - durationSize.width - [MCStyle contentInsetII].right;
    CGFloat currentX = CGRectGetMaxX(self.playBtn.frame) + [MCStyle contentInsetIII].left;

    if (self.styleSizeType == MCPlayerStyleSizeClassRegularHalf) {
        currentX = [MCStyle contentInsetIII].left;
        durationX = currentX + currentSize.width;
    }

    self.durationLabel.frame = CGRectMake(durationX,
            (CGRectGetHeight(self.frame) - self.durationLabel.font.lineHeight) / 2.0f,
            durationSize.width,
            self.durationLabel.font.lineHeight);

    self.currentLabel.frame = CGRectMake(currentX,
            (CGRectGetHeight(self.frame) - self.currentLabel.font.lineHeight) / 2.0f,
            currentSize.width,
            self.currentLabel.font.lineHeight);


    CGFloat progressX = CGRectGetMaxX(self.currentLabel.frame) + [MCStyle contentInsetII].left;
    CGFloat progressW = CGRectGetMinX(self.durationLabel.frame) - CGRectGetMaxX(self.currentLabel.frame) - [MCStyle contentInsetII].right - [MCStyle contentInsetII].left;

    if (self.styleSizeType == MCPlayerStyleSizeClassRegularHalf) {
        progressX = CGRectGetMaxX(self.durationLabel.frame) + [MCStyle contentInsetII].left;
        progressW = CGRectGetMinX(self.rightView.frame) - CGRectGetMaxX(self.durationLabel.frame) - [MCStyle contentInsetII].right - [MCStyle contentInsetII].left;
    }
    self.playerProgress.frame = CGRectMake(progressX,
            CGRectGetHeight(self.frame) * 0.25,
            progressW,
            CGRectGetHeight(self.frame) * 0.5f);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addLayout];
}

#pragma mark - MCPlayerProgressDelegate

- (void)controlProgressStartDragSlider {
    if (self.callBack) {
        self.callBack(kMCControlProgressStartDragSlider, nil);
    }
}

- (void)dragProgressToProgress:(float)value {
    if (self.callBack) {
        self.callBack(kMCDragProgressToProgress, @(value));
    }
}

- (void)controlProgressEndDragSlider {
    if (self.callBack) {
        self.callBack(kMCControlProgressEndDragSlider, nil);
    }
}

#pragma mark - getter

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton new];
        [_playBtn setImage:[MCStyle customImage:@"player_footer_0"] forState:UIControlStateNormal];
        [_playBtn setImage:[MCStyle customImage:@"player_footer_0_s"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _playBtn.hidden = YES;
    }
    return _playBtn;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [UILabel new];
        _durationLabel.font = [MCFont fontV];
        _durationLabel.textColor = [MCColor colorI];
    }
    return _durationLabel;
}

- (UILabel *)currentLabel {
    if (!_currentLabel) {
        _currentLabel = [UILabel new];
        _currentLabel.font = [MCFont fontV];
        _currentLabel.textColor = [MCColor colorI];
    }
    return _currentLabel;
}

- (MCPlayerProgress *)playerProgress {
    if (!_playerProgress) {
        _playerProgress = [MCPlayerProgress new];
        _playerProgress.delegate = self;
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

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(__bridge id) [MCColor rgba:0x00000005].CGColor, (__bridge id) [MCColor rgba:0x00000099].CGColor];
        _gradientLayer.locations = @[@(.3)];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1.0);
    }
    return _gradientLayer;
}

- (MCCustomActionView *)rightView {
    if (!_rightView) {
        _rightView = [MCCustomActionView new];
    }
    return _rightView;
}

- (void)setUnableSeek:(BOOL)unableSeek {
    self.playerProgress.userInteractionEnabled = !unableSeek;
}

@end

//
// Created by majiancheng on 2017/3/17.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "MCPlayerProgress.h"

#import "MCPlayerViewConfig.h"
#import "MCPlayerKitDef.h"

@interface MCPlayerProgress ()
@property(nonatomic, strong) UISlider *slider;
@property(nonatomic, strong) UIProgressView *progressView;
@property(nonatomic, strong) UIProgressView *bufferProgressView;
@property(nonatomic, assign) SliderStyle sliderStyle;

@end

@implementation MCPlayerProgress

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addSubview:self.bufferProgressView];
    [self addSubview:self.progressView];
    [self addSubview:self.slider];
    [self addLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addLayout];
}

- (void)addLayout {
    if (CGRectIsEmpty(self.frame))
        return;
    self.slider.frame = self.bounds;
    CGFloat y = (CGRectGetHeight(self.frame) - 2) / 2.0f;
    CGFloat w = CGRectGetWidth(self.frame);
    self.progressView.frame = CGRectMake(0, y, w, 2);
    self.bufferProgressView.frame = self.progressView.frame;
}

- (void)updateProgress:(float)progress {
    _slider.value = progress;
    _progressView.progress = progress;
}

- (void)updateBufferProgress:(float)progress {
    _bufferProgressView.progress = progress;
}

- (void)changeSliderStyle:(SliderStyle)sliderStyle {
    if (_sliderStyle == sliderStyle) return;
    _sliderStyle = sliderStyle;

    switch (sliderStyle) {
        case SliderShowAll: {
            _slider.hidden = NO;
        }
            break;
        case SliderShowSliderProgress: {

            _slider.hidden = NO;
        }
            break;
        case SliderShowProgress: {

            _slider.hidden = YES;
        }
            break;
    }

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

#pragma mark -
#pragma mark action

- (void)progressSliderValueDidChanged:(UISlider *)slider {
    _progressView.progress = slider.value;
    if ([_delegate respondsToSelector:@selector(dragProgressToProgress:)]) {
//        [_delegate dragProgressToProgress:_progressView.progress];
    }
    //取消隐藏控件

}

- (void)progressSliderActionDown:(UISlider *)slider {
    _progressView.progress = slider.value;
    //取消隐藏控件事件
    if ([_delegate respondsToSelector:@selector(controlProgressStartDragSlider)]) {
        [_delegate controlProgressStartDragSlider];
    }
}

- (void)progressSliderActionUp:(UISlider *)slider {
    _progressView.progress = slider.value;
    //增加隐藏控件事件
    if ([_delegate respondsToSelector:@selector(controlProgressEndDragSlider)]) {
        [_delegate dragProgressToProgress:_slider.value];
        [_delegate controlProgressEndDragSlider];
    }
}

#pragma mark - getter

- (UISlider *)slider {
    if (!_slider) {
        _slider = [UISlider new];
        [_slider setThumbImage:[UIImage imageNamed:@"player_slider"] forState:UIControlStateNormal];
        _slider.minimumTrackTintColor = [UIColor clearColor];
        _slider.maximumTrackTintColor = [UIColor clearColor];
        [_slider addTarget:self action:@selector(progressSliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(progressSliderActionDown:) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(progressSliderActionUp:) forControlEvents:UIControlEventTouchUpInside];
        [_slider addTarget:self action:@selector(progressSliderActionUp:) forControlEvents:UIControlEventTouchCancel];
        [_slider addTarget:self action:@selector(progressSliderActionUp:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _slider;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [UIProgressView new];
        _progressView.progressTintColor = [MCPlayerViewConfig colorIV];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

- (UIProgressView *)bufferProgressView {
    if (!_bufferProgressView) {
        _bufferProgressView = [UIProgressView new];
        _bufferProgressView.progressTintColor = [MCPlayerViewConfig colorVI];
        _bufferProgressView.trackTintColor = [MCPlayerViewConfig colorVII];
    }
    return _bufferProgressView;
}
@end

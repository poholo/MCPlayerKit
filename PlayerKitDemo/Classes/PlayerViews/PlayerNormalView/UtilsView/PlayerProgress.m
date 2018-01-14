//
// Created by majiancheng on 2017/3/17.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "PlayerProgress.h"
#import "PlayerViewConfig.h"

#import <Masonry.h>

@implementation PlayerProgress {

}


- (instancetype)init {
    if (self = [super init]) {
        _bufferProgressView = [[UIProgressView alloc] init];
        _progressView = [[UIProgressView alloc] init];
        _slider = [[UISlider alloc] init];

        [self addSubview:_bufferProgressView];
        [self addSubview:_progressView];
        [self addSubview:_slider];
        [self initStyle];
        [self addAction];
    }
    return self;
}

- (void)initStyle {
    [_slider setThumbImage:[UIImage imageNamed:@"player_slider"] forState:UIControlStateNormal];

    _slider.minimumTrackTintColor = [UIColor clearColor];
    _slider.maximumTrackTintColor = [UIColor clearColor];

    _bufferProgressView.progressTintColor = [PlayerViewConfig colorVI];
    _bufferProgressView.trackTintColor = [PlayerViewConfig colorVII];
    _progressView.progressTintColor = [PlayerViewConfig colorIV];
    _progressView.trackTintColor = [UIColor clearColor];
}

- (void)addAction {
    [_slider addTarget:self action:@selector(progressSliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    [_slider addTarget:self action:@selector(progressSliderActionDown:) forControlEvents:UIControlEventTouchDown];
    [_slider addTarget:self action:@selector(progressSliderActionUp:) forControlEvents:UIControlEventTouchUpInside];
    [_slider addTarget:self action:@selector(progressSliderActionUp:) forControlEvents:UIControlEventTouchCancel];
    [_slider addTarget:self action:@selector(progressSliderActionUp:) forControlEvents:UIControlEventTouchUpOutside];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutIfNeeded];
}

- (void)updateConstraints {
    __weak typeof(self) weakSelf = self;
    [_slider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        if (_sliderStyle == SliderShowProgress) {
            make.centerY.equalTo(self.mas_bottom).offset(-1);
        } else {
            make.centerY.equalTo(self);
        }
    }];

    [_progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        if (_sliderStyle == SliderShowProgress) {
            make.centerY.equalTo(self.mas_bottom).offset(-1);
        } else {
            make.centerY.equalTo(self);
        }
    }];

    [_bufferProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        if (_sliderStyle == SliderShowProgress) {
            make.centerY.equalTo(self.mas_bottom).offset(-1);
        } else {
            make.centerY.equalTo(self);
        }
    }];
    [super updateConstraints];
}

- (void)updateProgress:(CGFloat)progress {
    _slider.value = progress;
    _progressView.progress = progress;
}

- (void)updateBufferProgress:(CGFloat)progress {
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
@end

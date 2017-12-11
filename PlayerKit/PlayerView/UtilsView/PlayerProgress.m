 //
// Created by majiancheng on 2017/3/17.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "PlayerProgress.h"

#import "MASViewAttribute.h"
#import "UIImage+ImageWithColor.h"
#import "ViewShapeMask.h"
#import "WaQuColor.h"
#import "PlayerKitLog.h"

@implementation __SliderPointDto

- (instancetype)init {
    if (self = [super init]) {
        self.normalColor = [WaQuColor colorV];
        self.hightedColor = [WaQuColor colorIV];

        self.normalRadius = 5;
        self.hightedRadius = 10;
    }
    return self;
}
@end

@implementation __SliderPointBtn

- (void)setDto:(__SliderPointDto *)dto {
    _dto = dto;

    CGFloat rate = 0.2f;
    CGFloat marginRate = (1 - rate) / 2.0f;
    UIImage *normalImage = [UIImage imageWithColor:_dto.normalColor
                                              size:CGSizeMake(self.frame.size.width * rate, self.frame.size.width * rate)
                                            xSpace:self.frame.size.width * marginRate
                                            ySpace:self.frame.size.width * marginRate
                                      cornorRadius:self.frame.size.width * rate / 2.0f];


    UIImage *hightedImage = [UIImage imageWithColor:_dto.hightedColor
                                               size:CGSizeMake(self.frame.size.width * rate, self.frame.size.width * rate)
                                             xSpace:self.frame.size.width * marginRate
                                             ySpace:self.frame.size.width * marginRate
                                       cornorRadius:self.frame.size.width * rate / 2.0f];

    [self setImage:normalImage forState:UIControlStateNormal];
    [self setImage:hightedImage forState:UIControlStateHighlighted];
    [ViewShapeMask cornerView:self radius:self.frame.size.width / 2.0f border:0 color:nil];
}

@end

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

    _bufferProgressView.progressTintColor = [WaQuColor colorVI];
    _bufferProgressView.trackTintColor = [WaQuColor colorVII];
    _progressView.progressTintColor =[WaQuColor colorIV];
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
    @weakify(self);
    [_slider mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        if (_sliderStyle == SliderShowProgress) {
            make.centerY.equalTo(self.mas_bottom).offset(-1);
        } else {
            make.centerY.equalTo(self);
        }
    }];

    [_progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        if (_sliderStyle == SliderShowProgress) {
            make.centerY.equalTo(self.mas_bottom).offset(-1);
        } else {
            make.centerY.equalTo(self);
        }
    }];

    [_bufferProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
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

- (void)refreshDots:(NSArray<__SliderPointDto *> *)dtos {
    if (_sliderPointBtns == nil) {
        _sliderPointBtns = [NSMutableArray<__SliderPointBtn *> array];
    }

    @weakify(self);
    [_sliderPointBtns enumerateObjectsUsingBlock:^(__SliderPointBtn *btn, NSUInteger idx, BOOL *stop) {
        @strongify(self);
        [btn removeFromSuperview];
    }];

    [_sliderPointBtns removeAllObjects];

    CGFloat top = CGRectGetHeight(self.frame) / 2.0f - self.frame.size.height / 2.0f;
    [dtos enumerateObjectsUsingBlock:^(__SliderPointDto *dto, NSUInteger idx, BOOL *stop) {
        @strongify(self);
        __SliderPointBtn *btn = [[__SliderPointBtn alloc] initWithFrame:CGRectMake(dto.xStartRate * self.frame.size.width - self.frame.size.height / 2.0f, top, self.frame.size.height, self.frame.size.height)];
        btn.dto = dto;
        [btn addTarget:self action:@selector(sliderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self->_sliderPointBtns addObject:btn];
        [self insertSubview:btn belowSubview:self->_slider];
    }];
}

- (void)refreshDotsFrame {
    CGFloat top = CGRectGetHeight(self.frame) / 2.0f - self.frame.size.height / 2.0f;
    @weakify(self);
    [self->_sliderPointBtns enumerateObjectsUsingBlock:^(__SliderPointBtn *btn, NSUInteger idx, BOOL *stop) {
        @strongify(self);
        btn.frame = CGRectMake(btn.dto.xStartRate * self.frame.size.width - self.frame.size.height / 2.0f, top, self.frame.size.height, self.frame.size.height);
    }];
}


- (void)changeSliderStyle:(SliderStyle)sliderStyle {
    if (_sliderStyle == sliderStyle) return;
    _sliderStyle = sliderStyle;

    switch (sliderStyle) {
        case SliderShowAll: {
            [_sliderPointBtns enumerateObjectsUsingBlock:^(__SliderPointBtn *obj, NSUInteger idx, BOOL *stop) {
                obj.hidden = NO;
            }];
            _slider.hidden = NO;
        }
            break;
        case SliderShowSliderProgress: {
            [_sliderPointBtns enumerateObjectsUsingBlock:^(__SliderPointBtn *obj, NSUInteger idx, BOOL *stop) {
                obj.hidden = YES;
            }];
            _slider.hidden = NO;
        }
            break;
        case SliderShowProgress: {
            [_sliderPointBtns enumerateObjectsUsingBlock:^(__SliderPointBtn *obj, NSUInteger idx, BOOL *stop) {
                obj.hidden = YES;
            }];
            _slider.hidden = YES;
        }
            break;
    }

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}


- (void)sliderBtnClick:(__SliderPointBtn *)btn {
    PKLog(@"~~~~~[Progres][Slider][click]");
    if ([self.delegate respondsToSelector:@selector(sliderPointClick:)]) {
        [self.delegate sliderPointClick:btn.dto.snapDto];
    }
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

//
// Created by majiancheng on 2017/3/17.
// Copyright (c) 2017 mjc inc. All rights reserved.
//


#import <UIKit/UIKit.h>

@class MASViewAttribute;

@protocol PlayerProgressDelegate <NSObject>

- (void)controlProgressStartDragSlider;

- (void)dragProgressToProgress:(float)value;

- (void)controlProgressEndDragSlider;

@end

typedef NS_ENUM(NSInteger, SliderStyle) {
    SliderShowAll,
    SliderShowSliderProgress,
    SliderShowProgress
};


@interface PlayerProgress : UIView {
@public
    UISlider *_slider;

@protected
    UIProgressView *_progressView;
    UIProgressView *_bufferProgressView;
    SliderStyle _sliderStyle;
}

@property(nonatomic, weak) id <PlayerProgressDelegate> delegate;

- (void)updateProgress:(CGFloat)progress;

- (void)updateBufferProgress:(CGFloat)progress;

- (void)changeSliderStyle:(SliderStyle)sliderStyle;


@end

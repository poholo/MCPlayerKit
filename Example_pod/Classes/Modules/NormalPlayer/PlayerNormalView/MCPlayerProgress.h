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

/**
    player_progress_color
    player_progress_buffer_trackcolor
    player_progress_buffer_color
 */

@interface MCPlayerProgress : UIView

@property(nonatomic, weak) id <PlayerProgressDelegate> delegate;

- (void)updateProgress:(float)progress;

- (void)updateBufferProgress:(float)progress;

- (void)changeSliderStyle:(SliderStyle)sliderStyle;


@end

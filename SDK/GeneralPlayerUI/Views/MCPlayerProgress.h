//
// Created by majiancheng on 2017/3/17.
// Copyright (c) 2017 mjc inc. All rights reserved.
//


#import <UIKit/UIKit.h>

@class MASViewAttribute;

@protocol MCPlayerProgressDelegate <NSObject>

- (void)controlProgressStartDragSlider;

- (void)dragProgressToProgress:(float)value;

- (void)controlProgressEndDragSlider;

@end

typedef NS_ENUM(NSInteger, MCSliderStyle) {
    MCSliderShowAll,
    MCSliderShowSliderProgress,
    MCSliderShowProgress
};

/**
    player_progress_color
    player_progress_buffer_trackcolor
    player_progress_buffer_color
 */

@interface MCPlayerProgress : UIView

@property(nonatomic, weak) id <MCPlayerProgressDelegate> delegate;

- (void)updateProgress:(float)progress;

- (void)updateBufferProgress:(float)progress;

- (void)changeSliderStyle:(MCSliderStyle)sliderStyle;


@end

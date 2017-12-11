//
// Created by majiancheng on 2017/3/17.
// Copyright (c) 2017 mjc inc. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Dto.h"

@class MASViewAttribute;
@class __SliderPointDto;
@class SnapDto;

@protocol PlayerProgressDelegate <NSObject>

- (void)controlProgressStartDragSlider;

- (void)dragProgressToProgress:(float)value;

- (void)controlProgressEndDragSlider;

@optional
- (void)sliderPointClick:(SnapDto *)snapDto;

@end

typedef NS_ENUM(NSInteger, SliderStyle) {
    SliderShowAll,
    SliderShowSliderProgress,
    SliderShowProgress
};

@interface __SliderPointDto : Dto

@property(nonatomic, strong) SnapDto *snapDto;
@property(nonatomic, assign) CGFloat xStartRate;
@property(nonatomic, assign) BOOL selected;

@property(nonatomic, strong) UIColor *normalColor;
@property(nonatomic, strong) UIColor *hightedColor;

@property(nonatomic, assign) CGFloat normalRadius;
@property(nonatomic, assign) CGFloat hightedRadius;

@end

@interface __SliderPointBtn : UIButton

@property(nonatomic, strong) __SliderPointDto *dto;

@end

@interface PlayerProgress : UIView {
    @public
    UISlider *_slider;
    @protected
    UIProgressView *_progressView;
    UIProgressView *_bufferProgressView;

    NSMutableArray<__SliderPointBtn *> *_sliderPointBtns;
    SliderStyle _sliderStyle;
}

@property(nonatomic, weak) id <PlayerProgressDelegate> delegate;

@property(nonatomic, strong) MASViewAttribute *showAllLeftAttribute;
@property(nonatomic, strong) MASViewAttribute *showAllRightAttribute;

@property(nonatomic, strong) MASViewAttribute *showProgressLeftAttribute;
@property(nonatomic, strong) MASViewAttribute *showProgressRightAttribute;

- (void)updateProgress:(CGFloat)progress;

- (void)updateBufferProgress:(CGFloat)progress;

- (void)refreshDots:(NSArray<__SliderPointDto *> *)dtos;

- (void)refreshDotsFrame;

- (void)changeSliderStyle:(SliderStyle)sliderStyle;


@end

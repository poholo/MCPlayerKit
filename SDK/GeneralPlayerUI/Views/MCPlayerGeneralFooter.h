//
// Created by majiancheng on 2018/12/28.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCPlayerGeneralView.h"

@class MCPlayerProgress;
@class MCCustomActionView;

extern NSString *const kMCPlayer2HalfScreenAction;
extern NSString *const kMCPlayer2FullScreenAction;
extern NSString *const kMCPlayer2PlayAction;
extern NSString *const kMCPlayer2PauseAction;
extern NSString *const kMCControlProgressStartDragSlider;
extern NSString *const kMCDragProgressToProgress;
extern NSString *const kMCControlProgressEndDragSlider;

@interface MCPlayerGeneralFooter : UIView

@property(nonatomic, readonly) UIButton *playBtn;
@property(nonatomic, copy) MCPlayerNormalViewEventCallBack callBack;
@property(nonatomic, readonly) MCCustomActionView *rightView;
@property(nonatomic, assign) BOOL unableSeek;
@property(nonatomic, assign) BOOL isLive;

- (void)updatePlayerStyle:(MCPlayerStyleSizeType)styleSizeType;

- (void)currentTime:(double)time;

- (void)duration:(double)time;

- (void)updateProgress:(float)progress;

- (void)updateBufferProgress:(float)progress;

- (void)fadeHiddenControl;

- (void)showControl;

@end
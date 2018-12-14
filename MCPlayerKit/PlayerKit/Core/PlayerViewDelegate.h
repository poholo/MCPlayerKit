//
// Created by majiancheng on 2017/3/17.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayerViewDelegate <NSObject>

@optional

- (void)showPlayBtnPlay:(BOOL)isPlay;

- (void)updatePlayerView:(UIView *)drawPlayerView;

- (void)updatePlayerLayer:(CALayer *)layer;

- (void)refreshNatureSize:(CGSize)size;

/** WQPlayerStateLoading,   */
- (void)showLoading;

- (void)showLoadingNoDefaultBg;

/** WQPlayerStateBuffering,  ///< 缓冲中   */
- (void)showBuffering;

/** WQPlayerStateStarting,   ///< 开始播放  */
- (void)showStateStarting;

/** WQPlayerStatePlaying,    ///< 播放中   */
- (void)showPlaying;

/** WQPlayerStatePlayEnd,    ///< 播放结束  */
- (void)showPlayEnd;

/** WQPlayerStatePausing,    ///< 暂停    */
- (void)showPausing;

/** WQPlayerStateStopped,    ///< 停止播放  */
- (void)showStopped;

/** WQPlyaerState3GUnenable */
- (void)show3GUnenable;

/** WQPlayerStateNetError,  ///< 播放错误[网络]  */
- (void)showNetError;

/** WQPlayerStateUrlError,  ///< 播放路径错误    */
- (void)showUrlError;

/** WQPlayerStateError,     ///< 播放路径错误    */
- (void)showError;

//////////////////////ControlDelegate/////////////////////////////////
- (void)updateLeftTime:(nonnull NSString *)leftTime;

- (void)updateRightTime:(nonnull NSString *)rightTime;

- (void)updatePlayPauseState:(BOOL)isPlay;

- (void)updateProgress:(CGFloat)progress;

- (void)updateBufferProgress:(CGFloat)progress;

- (BOOL)canRotate;

@end

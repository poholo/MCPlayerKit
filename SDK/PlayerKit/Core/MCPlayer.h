//
// Created by majiancheng on 16/5/18.
// Copyright (c) 2016 mjc inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "MCPlayerConfig.h"

@interface MCPlayer : NSObject {
    MCPlayerState _playerState;
    CGFloat _cacheProgress;
    CGFloat _rate;
    BOOL _enableVideoToolBox; // default NO

}

@property(nonatomic, assign) MCPlayerState playerState;
@property(nonatomic, assign) CGFloat cacheProgress; ///< 0.0 ~ 1.0
@property(nonatomic, assign) CGFloat rate;
@property(nonatomic, assign) MCPlayerActionAtItemEnd actionAtItemEnd;
@property(nonatomic, assign) MCPlayerLayerVideoGravity playerLayerVideoGravity;
@property(nonatomic, assign) BOOL notNeedSetProbesize;

@property(nonatomic, assign) CFAbsoluteTime startTime;
@property(nonatomic, assign) CFAbsoluteTime startEndTime;

#pragma mark - play

- (void)playUrls:(nonnull NSArray<NSString *> *)urls;

- (void)playUrls:(nonnull NSArray<NSString *> *)urls isLiveOptions:(BOOL)isLiveOptions;

#pragma mark -config

- (void)enableVideoToolBox:(BOOL)enable;

- (nonnull CALayer *)playerLayer;

- (nonnull UIView *)playerView;

- (MCPlayerCoreType)playerType;

#pragma mark - control

- (void)preparePlay;

- (void)preParePlayContainView:(UIView *)containView;

- (void)updatePlayerView:(UIView *)playerView;

- (void)play;

- (void)pause;

- (BOOL)isPlaying;

- (void)seekSeconds:(CGFloat)seconds;

- (void)playRate:(CGFloat)playRate;

- (CGFloat)rate;

- (NSTimeInterval)currentTime; //sec
- (NSTimeInterval)duration;    //sec

- (void)cancelLoading;

- (void)changeAudioVolume:(CGFloat)volume;

- (CGSize)naturalSize;

#pragma mark - memory

- (void)destory;

- (void)releaseSpace;


@end

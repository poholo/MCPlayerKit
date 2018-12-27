//
// Created by majiancheng on 16/5/18.
// Copyright (c) 2016 mjc inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "PlayerConfig.h"

@interface Player : NSObject {
    PlayerState _playerState;
    CGFloat _cacheProgress;
    CGFloat _rate;
    BOOL _enableVideoToolBox; // default NO

}

@property(nonatomic, assign) PlayerState playerState;
@property(nonatomic, assign) CGFloat cacheProgress; ///< 0.0 ~ 1.0
@property(nonatomic, assign) CGFloat rate;
@property(nonatomic, assign) PlayerActionAtItemEnd actionAtItemEnd;
@property(nonatomic, assign) PlayerLayerVideoGravity playerLayerVideoGravity;
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

- (PlayerCoreType)playerType;

#pragma mark - control

- (void)preparePlay;

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
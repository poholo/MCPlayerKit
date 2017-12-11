//
// Created by majiancheng on 16/5/18.
// Copyright (c) 2016 mjc inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "PlayerConfig.h"
#import "PlayerViewControlDelegate.h"
#import "PlayerConfig.h"


@protocol PlayerDelegate <NSObject>

@optional

- (void)loading;

- (void)startPlay;

- (void)pauseCaching;

- (void)cacheProgress:(float)cacheRate;

- (void)playError;

- (void)playEndPause;

- (void)playFinish;

- (void)replay;

- (void)changePlayerState:(PlayerState)playerState;

- (void)changeCurrentPlayerIndex:(NSInteger)currentIndex;

- (void)updatePlayerLayer;

- (void)changePlayer:(PlayerCoreType)currentPlayerType;

- (void)adpaterPlayRate;

- (BOOL)playerCanAutoPlay;

- (void)isPlaySmarty;

- (void)finishCirclePlay;


@end

@interface Player : NSObject <PlayerViewControlDelegate> {
    PlayerState _playerState;
    CGFloat _cacheProgress;
    CGFloat _rate;
    __weak id <PlayerDelegate> _delegate;
    BOOL _enableVideoToolBox; // default NO

}

@property(nonatomic, assign) PlayerState playerState;
@property(nonatomic, assign) CGFloat cacheProgress; ///< 0.0 ~ 1.0
@property(nonatomic, assign) CGFloat rate;
@property(nonatomic, nullable, weak) id <PlayerDelegate> delegate;
@property(nonatomic, assign) BOOL isRecording;
@property(nonatomic, copy) NSString *recordFilePath;

@property(nonatomic, assign) PlayerActionAtItemEnd actionAtItemEnd;
@property(nonatomic, assign) BOOL notNeedSetProbesize;

/***
 * must set before 'playUrls:'
 * @param enable
 */
- (void)enableVideoToolBox:(BOOL)enable;

- (void)releaseSpace;

/***
 * must set before 'playUrls:'
 * @param enable
 */
- (void)enableVideoToolBox:(BOOL)enable;

- (void)playUrls:(nonnull NSArray<NSString *> *)urls;

- (void)playUrls:(nonnull NSArray<NSString *> *)urls isLiveOptions:(BOOL)isLiveOptions;

- (void)preparePlay;

- (void)play;

- (void)pause;

- (BOOL)isPlaying;

- (void)seekSeconds:(CGFloat)seconds;

- (void)playRate:(CGFloat)playRate;

- (CGFloat)rate;

- (void)destory;

- (NSTimeInterval)currentTime; //sec
- (NSTimeInterval)duration;    //sec

- (nonnull CALayer *)playerLayer;

- (nonnull UIView *)playerView;

- (PlayerCoreType)playerType;

- (NSInteger)currentPlayerItemIndex;

- (BOOL)hasNextVideoItem;

- (void)playNextVideoItem;

- (void)changePlayerState:(PlayerState)playerState;

- (void)playFinish;

- (void)playError;

- (void)updatePlayerLayer;

- (void)changePlayer:(PlayerCoreType)currentPlayerType;

- (void)cancelLoading;

- (void)changeAudioVolume:(CGFloat)volume;

- (CGSize)naturalSize;

@end
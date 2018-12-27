//
//  PlayerKit.h
//  WaQuVideo
//
//  Created by majiancheng on 2017/3/17.
//  Copyright © 2017年 mjc inc. All rights reserved.
//


#import "PlayerConfig.h"

@class Player;
@class PlayerBaseView;


@protocol PlayerDelegate <NSObject>

- (void)playLoading;

- (void)playBuffer;

- (void)playStart;

- (void)playPlay;

- (void)playEnd;

- (void)playError;

- (void)updatePlayView;

- (void)currentTime:(double)time;

@end

@interface PlayerKit : NSObject {
@public
    Player *_player;
    __weak PlayerBaseView *_playerView;
}

@property(nonatomic, assign) PlayerEnvironment playerEnvironment;
@property(nonatomic, assign) PlayerCoreType playerCoreType; ///< default IJKPlayer
@property(nonatomic, assign) PlayerActionAtItemEnd actionAtItemEnd;
@property(nonatomic, assign) PlayerLayerVideoGravity playerLayerVideoGravity;
@property(nonatomic, assign) BOOL notNeedSetProbesize;
@property(nonatomic, weak) id <PlayerDelegate> delegate;


- (instancetype)initWithPlayerView:(PlayerBaseView *)playerView;

- (void)updatePlayerView:(PlayerBaseView *)playerView;

- (void)playUrls:(nonnull NSArray<NSString *> *)urls;

- (void)playUrls:(nonnull NSArray<NSString *> *)urls isLiveOptions:(BOOL)isLiveOptions;

- (void)preparePlay;

- (void)play;

- (void)pause;

- (void)destory;

- (NSTimeInterval)duration;

- (NSTimeInterval)currentTime;

- (void)seekSeconds:(CGFloat)seconds;

- (BOOL)isPlaying;

- (CGSize)naturalSize;

- (BOOL)conditionLimit2CannotPlay;

@end

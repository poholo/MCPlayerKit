//
//  PlayerKit.h
//  WaQuVideo
//
//  Created by majiancheng on 2017/3/17.
//  Copyright © 2017年 mjc inc. All rights reserved.
//

#import "Player.h"
#import "PlayerBaseView.h"
#import "PlayerStatusDelegate.h"

@protocol PlayerViewDelegate;

@interface PlayerKit : NSObject {
    Player *_player;
    __weak PlayerBaseView <PlayerViewDelegate> *_playerView;
}


@property(nonatomic, assign) PlayerStyle playerStyle;

@property(nonatomic, weak) id <PlayerStatusDelegate> playerStatusDelegate;
@property(nonatomic, assign) PlayerEnvironment playerEnvironment;
@property(nonatomic, assign) PlayerUserStatus playerUserStatus;
@property(nonatomic, assign) PlayerCoreType playerCoreType; ///< default IJKPlayer
@property(nonatomic, strong, readonly) NSArray<NSString *> *urls;
@property(nonatomic, assign) PlayerActionAtItemEnd actionAtItemEnd;
@property(nonatomic, assign) BOOL notNeedSetProbesize;

- (instancetype)initWithPlayerView:(PlayerBaseView <PlayerViewDelegate> *)playerView;

- (void)updatePlayerView:(PlayerBaseView <PlayerViewDelegate> *)playerView;

- (void)playUrls:(nonnull NSArray<NSString *> *)urls;

- (void)playUrls:(nonnull NSArray<NSString *> *)urls isLiveOptions:(BOOL)isLiveOptions;

- (void)play;

- (void)pause;

- (void)destoryPlayer;

- (NSTimeInterval)duration;

- (NSTimeInterval)currentTime;

- (void)seekSeconds:(CGFloat)seconds;

- (BOOL)isPlaying;

- (CGSize)naturalSize;

- (BOOL)conditionLimit2CannotPlay;

@end

//
//  PlayerKit.m
//  WaQuVideo
//
//  Created by majiancheng on 2017/3/17.
//  Copyright © 2017年 mjc inc. All rights reserved.
//


#import "PlayerKit.h"

#import "IJKPlayer.h"
#import "AVPlayerx.h"
#import "PlayerKitLog.h"
#import "Player.h"
#import "PlayerKitTools.h"
#import "PlayerBaseView.h"
#import "PlayerStatusDelegate.h"


@interface PlayerKit () <PlayerDelegate, PlayerViewControlDelegate>

/** 计时器 */
@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, strong) NSArray<NSString *> *urls;
@property(nonatomic, assign) BOOL isPause;

@end

@implementation PlayerKit

- (void)dealloc {
    [self destoryPlayer];
}

- (instancetype)initWithPlayerView:(PlayerBaseView <PlayerViewDelegate> *)playerView {
    self = [super init];
    if (self) {
        _playerView = playerView;

        if ([_playerView respondsToSelector:@selector(showLoading)]) {
            [_playerView showLoading];
        }
        self.playerEnvironment = PlayerEnvironmentOnBecomeActiveStatus;

        _playerView.playerControlDelegate = self;
    }
    return self;
}

- (void)updatePlayerView:(PlayerBaseView <PlayerViewDelegate> *)playerView {
    _playerView = playerView;
    _playerView.playerControlDelegate = self;
    self.playerEnvironment = PlayerEnvironmentOnBecomeActiveStatus;
    [self updatePlayerLayer];
}

- (void)destoryPlayer {
    [self fireTimer];
    [_player destory];
    _player = nil;
}

- (NSTimeInterval)duration {
    return [_player duration];
}

- (NSTimeInterval)currentTime {
    return [_player currentTime];
}

- (BOOL)isPlaying {
    return [_player isPlaying];
}

- (void)setActionAtItemEnd:(PlayerActionAtItemEnd)actionAtItemEnd {
    _actionAtItemEnd = actionAtItemEnd;
    _player.actionAtItemEnd = actionAtItemEnd;
}

- (void)seekSeconds:(CGFloat)seconds {
    [_player seekSeconds:seconds];
    if ([self.playerStatusDelegate respondsToSelector:@selector(afterSeekNeed2Play)]) {
        BOOL need2Play = [self.playerStatusDelegate afterSeekNeed2Play];
        if (need2Play) {
            [self play];
        } else {
            [self pause];
        }
    } else {
        [self play];
    }
}

- (CGSize)naturalSize {
    return [_player naturalSize];
}

- (BOOL)conditionLimit2CannotPlay {
    if (self.playerEnvironment == PlayerEnvironmentOnResignActiveStatus) {
        return YES;
    }

    if (self.playerUserStatus == PlayerUserAirplayStatus) {
        return YES;
    } else {
        if (self.playerUserStatus == PlayerUserPauseStatus) {
            return YES;
        }
    }
    return NO;
}


#pragma mark -
#pragma mark NSTimer

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(timeTick) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

- (void)fireTimer {
    if (_timer != nil || [_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)timeTick {
    double curSecs = _player.currentTime;
    double sumSecs = _player.duration;
    if ([_playerView respondsToSelector:@selector(updateProgress:)]
            && [_playerView respondsToSelector:@selector(updateLeftTime:)]
            && [_playerView respondsToSelector:@selector(updateRightTime:)]
            && [_playerView respondsToSelector:@selector(updateBufferProgress:)]) {
        [_playerView updateProgress:(CGFloat) (curSecs / sumSecs)];
        [_playerView updateLeftTime:[PlayerKitTools secondTimeString:(curSecs + .5)]];
        [_playerView updateRightTime:[PlayerKitTools secondTimeString:(sumSecs + .5)]];
        [_playerView updateBufferProgress:_player.cacheProgress];
    }

    if ([self.playerStatusDelegate respondsToSelector:@selector(currentTime:)]) {
        [self.playerStatusDelegate currentTime:self.currentTime];
    }
}

#pragma mark - PlayerDelegate


- (void)loading {
}

- (void)startPlay {
    if ([_playerView respondsToSelector:@selector(showStateStarting)]) {
        [_playerView showStateStarting];
    }
}

- (void)pauseCaching {
    if ([_playerView respondsToSelector:@selector(showBuffering)]) {
        [_playerView showBuffering];
    }
}

- (void)cacheProgress:(float)cacheRate {
    if ([_playerView respondsToSelector:@selector(updateBufferProgress:)]) {
        [_playerView updateBufferProgress:cacheRate];
    }
}

- (void)playError {
    if ([_playerView respondsToSelector:@selector(showError)]) {
        [_playerView showError];
    }
}

- (void)playFinish {
    if ([_playerView respondsToSelector:@selector(showPlayEnd)]) {
        [_playerView showPlayEnd];
    }

    if ([self.playerStatusDelegate respondsToSelector:@selector(playerEndplay)]) {
        [self.playerStatusDelegate playerEndplay];
    }

    if ([self.playerStatusDelegate respondsToSelector:@selector(playerEndAutoNext)]) {
        [self.playerStatusDelegate playerEndAutoNext];
    }
}

- (void)playEndPause {
    if ([self.playerStatusDelegate respondsToSelector:@selector(playEndPause)]) {
        [self.playerStatusDelegate playEndPause];
    }
}

- (void)replay {
    if ([self.playerStatusDelegate respondsToSelector:@selector(playerEndAutoNext)]) {
        [self.playerStatusDelegate playerEndAutoNext];
    }
}

- (void)changePlayerState:(PlayerState)playerState {
    PKLog(@"PlayerState == %zd", playerState);
    switch (playerState) {
        case PlayerStateNone: {
        }
            break;
        case PlayerStateLoading      : {
            if ([_playerView respondsToSelector:@selector(showLoading)]) {
                [_playerView showLoading];
            }

            if ([_playerView respondsToSelector:@selector(updateRightTime:)]) {
                [_playerView updateRightTime:[PlayerKitTools secondTimeString:_player.duration]];
            }
            [self timer];
        }
            break;
        case PlayerStateLoadingNoBg  : {

            if ([_playerView respondsToSelector:@selector(showLoadingNoDefaultBg)]) {
                [_playerView showLoadingNoDefaultBg];
            }
            [self timer];
        }
            break;
        case PlayerStateBuffering    : {

            if ([_playerView respondsToSelector:@selector(showBuffering)]) {
                [_playerView showBuffering];
            }
        }
            break;
        case PlayerStateStarting     : {
            [self pause];
            [self isPlaySmarty];
            [self timer];

            if ([_playerView respondsToSelector:@selector(showStateStarting)]) {
                [_playerView showStateStarting];
            }

            if ([self.playerStatusDelegate respondsToSelector:@selector(playerStartplay)]) {
                [self.playerStatusDelegate playerStartplay];
            }
            [self updatePlayerLayer];


//            if(self.changeDefinitionTypeCurrentTime > 0) {
//                [self  seekSeconds:self.changeDefinitionTypeCurrentTime];
//            }
//            else if([_playerDelegate respondsToSelector:@selector(jumpHistoryPlayRecordTime)]) {
//                [_playerDelegate jumpHistoryPlayRecordTime];
//            }
        }
            break;
        case PlayerStatePlaying      : {

            if ([_playerView respondsToSelector:@selector(showPlaying)]) {
                [_playerView showPlaying];
            }
        }
            break;
        case PlayerStatePlayEnd      : {

            if ([_playerView respondsToSelector:@selector(showPlayEnd)]) {
                [_playerView showPlayEnd];
            }
            if ([self.playerStatusDelegate respondsToSelector:@selector(playerEndAutoNext)]) {
                [self.playerStatusDelegate playerEndAutoNext];
            }
        }
            break;
        case PlayerStatePausing      : {

            if ([_playerView respondsToSelector:@selector(showPausing)]) {
                [_playerView showPausing];
            }
//            [self logCallBackStatus:self.playerState];
        }
            break;
        case PlayerStateStopped      : {

            if ([_playerView respondsToSelector:@selector(showStopped)]) {
                [_playerView showStopped];
            }
//            [self logCallBackStatus:self.playerState];
        }
            break;
        case PlayerState3GUnenable: {

            if ([_playerView respondsToSelector:@selector(show3GUnenable)]) {
                [_playerView show3GUnenable];
            }
//            [self pause:WQPlayerPauseBy3GCannotPlay];
        }
            break;
        case PlayerStateNetError    : {

            if ([_playerView respondsToSelector:@selector(showNetError)]) {
                [_playerView showNetError];
            }
//            [self pause:PlayerPauseBy3GCannotPlay];
        }
            break;
        case PlayerStateUrlError    : {

            if ([_playerView respondsToSelector:@selector(showUrlError)]) {
                [_playerView showUrlError];
            }
            if ([_playerStatusDelegate respondsToSelector:@selector(playerStartError)]) {
                [_playerStatusDelegate playerStartError];
            }
        }
            break;
        case PlayerStateError        : {
            if ([_playerView respondsToSelector:@selector(showError)]) {
                [_playerView showError];
            }
            if ([_playerStatusDelegate respondsToSelector:@selector(playerStartError)]) {
                [_playerStatusDelegate playerStartError];
            }
        }
            break;
        default: {

        }
            break;
    }
}

- (void)changeCurrentPlayerIndex:(NSInteger)currentIndex {

}


- (void)updatePlayerLayer {
    if ([_playerView respondsToSelector:@selector(updatePlayerLayer:)] && [_player playerLayer]) {
        [_playerView updatePlayerLayer:[_player playerLayer]];
    }

    if ([_playerView respondsToSelector:@selector(updatePlayerView:)] && [_player playerView]) {
        [_playerView updatePlayerView:[_player playerView]];
    }

    if ([_playerView respondsToSelector:@selector(refreshNatureSize:)]) {
        [_playerView refreshNatureSize:_player.naturalSize];
    }

}

- (void)isPlaySmarty {
    [self pause];
    [self play];
}

- (BOOL)playerCanAutoPlay {
    return YES;
}

- (void)finishCirclePlay {
    if ([self.playerStatusDelegate respondsToSelector:@selector(playerEndplay)]) {
        [self.playerStatusDelegate playerEndplay];
    }
}

#pragma mark - PlayerViewControlDelegate

- (void)playUrls:(nonnull NSArray<NSString *> *)urls {
    [self playUrls:urls isLiveOptions:NO];
}

- (void)playUrls:(nonnull NSArray<NSString *> *)urls isLiveOptions:(BOOL)isLiveOptions {
    [self destoryPlayer];
    self.urls = urls;
    _player = ({
        Player *player;
        if (self.playerCoreType == PlayerCoreIJKPlayer) {
            player = [[IJKPlayer alloc] init];
        } else if (self.playerCoreType == PlayerCoreAVPlayer) {
            player = [[AVPlayerx alloc] init];
        } else {
            player = [[IJKPlayer alloc] init];
        }
        player;
    });
    _player.actionAtItemEnd = self.actionAtItemEnd;
    [_player playUrls:urls isLiveOptions:isLiveOptions];
    _player.delegate = self;
    if ([_playerView respondsToSelector:@selector(showLoading)]) {
        [_playerView showLoading];
    }
}

- (void)destory {
    [_player destory];
}

- (void)preparePlay {
    if ([self conditionLimit2CannotPlay]) {
        return;
    }
    [_player preparePlay];
}

- (void)play {
    if ([self conditionLimit2CannotPlay]) {
        return;
    }
    [self timer];
    [_player preparePlay];
    [_player play];
    if ([_playerView respondsToSelector:@selector(showPlayBtnPlay:)]) {
        [_playerView showPlayBtnPlay:YES];
    }
}

- (void)pause {
    [self fireTimer];
    [_player pause];
    if ([_playerView respondsToSelector:@selector(showPlayBtnPlay:)]) {
        [_playerView showPlayBtnPlay:NO];
    }
}

- (void)cancelLoading {
    [_player cancelLoading];
}

- (void)playRate:(CGFloat)playRate {
    [_player playRate:playRate];
}

- (CGFloat)playRate {
    return [_player rate];
}

- (NSInteger)currentPlayerItemIndex {
    return [_player currentPlayerItemIndex];
}

- (BOOL)hasNextVideoItem {
    return [_player hasNextVideoItem];
}

- (void)playNextVideoItem {
    [_player playNextVideoItem];
}

- (void)changeAudioVolume:(CGFloat)volume {
    [_player changeAudioVolume:volume];
}

@end

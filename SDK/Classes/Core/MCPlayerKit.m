//
//  MCPlayerKit.m
//  WaQuVideo
//
//  Created by majiancheng on 2017/3/17.
//  Copyright © 2017年 mjc inc. All rights reserved.
//


#import "MCPlayerKit.h"

#import "MCIJKPlayer.h"
#import "MCAVPlayerx.h"
#import "MCPlayerBaseView.h"
#import "MCPlayerKitDef.h"


@interface MCPlayerKit ()

/** 计时器 */
@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, strong) NSArray<NSString *> *urls;

@property(nonatomic, assign) PlayerState playerState;

@end

@implementation MCPlayerKit

- (void)dealloc {
    [self destory];
}

- (instancetype)initWithPlayerView:(MCPlayerBaseView *)playerView {
    self = [super init];
    if (self) {
        _playerView = playerView;
        self.playerEnvironment = PlayerEnvironmentOnBecomeActiveStatus;
    }
    return self;
}

- (void)updatePlayerView:(MCPlayerBaseView *)playerView {
    _playerView = playerView;
    self.playerEnvironment = PlayerEnvironmentOnBecomeActiveStatus;

    if ([self.delegate respondsToSelector:@selector(updatePlayView)]) {
        [self.delegate updatePlayView];
    }
}

- (void)destory {
    [self fireTimer];
    if (_player) {
        [self removeObserver:_player forKeyPath:@"playerState"];
        [_player destory];
        _player = nil;
    }
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
}

- (CGSize)naturalSize {
    return [_player naturalSize];
}

- (BOOL)conditionLimit2CannotPlay {
    if (self.playerEnvironment == PlayerEnvironmentOnResignActiveStatus) {
        return YES;
    }
    return NO;
}


#pragma mark -
#pragma mark NSTimer

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(timeTick) userInfo:nil repeats:YES];
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
    if ([self.delegate respondsToSelector:@selector(currentTime:)]) {
        [self.delegate currentTime:curSecs];
    }
}


- (void)changePlayerState:(PlayerState)playerState {
    MCLog(@"PlayerState -> %zd", playerState);
    switch (playerState) {
        case PlayerStateLoading : {
            [self timer];
            if ([self.delegate respondsToSelector:@selector(playLoading)]) {
                [self.delegate playLoading];
            }
            if ([self.delegate respondsToSelector:@selector(updatePlayView)]) {
                [self.delegate updatePlayView];
            }
        }
            break;
        case PlayerStateBuffering: {
            if ([self.delegate respondsToSelector:@selector(playBuffer)]) {
                [self.delegate playBuffer];
            }
        }
            break;
        case PlayerStateStarting: {
            if ([self.delegate respondsToSelector:@selector(playStart)]) {
                [self.delegate playStart];
            }
        }
            break;
        case PlayerStatePlaying: {
            if ([self.delegate respondsToSelector:@selector(playPlay)]) {
                [self.delegate playPlay];
            }
        }
            break;
        case PlayerStatePlayEnd: {
            if ([self.delegate respondsToSelector:@selector(playEnd)]) {
                [self.delegate playEnd];
            }
        }
            break;
        case PlayerStateError: {
            if ([self.delegate respondsToSelector:@selector(playError)]) {
                [self.delegate playError];
            }
            [self fireTimer];
        }
            break;
    }
}


#pragma mark - PlayerViewControlDelegate

- (void)playUrls:(nonnull NSArray<NSString *> *)urls {
    [self playUrls:urls isLiveOptions:NO];
}

- (void)playUrls:(nonnull NSArray<NSString *> *)urls isLiveOptions:(BOOL)isLiveOptions {
    [self destory];
    self.playerState = PlayerStateNone;
    self.urls = urls;
    _player = ({
        MCPlayer *player;
        if (self.playerCoreType == PlayerCoreIJKPlayer) {
            player = [[MCIJKPlayer alloc] init];
        } else if (self.playerCoreType == PlayerCoreAVPlayer) {
            player = [[MCAVPlayerx alloc] init];
        } else {
            player = [[MCIJKPlayer alloc] init];
        }
        player;
    });
    _player.actionAtItemEnd = self.actionAtItemEnd;
    _player.playerLayerVideoGravity = self.playerLayerVideoGravity;
    [_player playUrls:urls isLiveOptions:isLiveOptions];

    [self addObserver:_player forKeyPath:@"playerState" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)preparePlay {
    if ([self conditionLimit2CannotPlay]) {
        return;
    }
    [_player preparePlay];
}

- (void)play {
    if ([self conditionLimit2CannotPlay]) {
        [self pause];
        return;
    }
    [self timer];
    [_player play];
}

- (void)pause {
    [self fireTimer];
    [_player pause];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    if ([keyPath isEqualToString:@"playerState"]) {
        PlayerState state = (PlayerState) [object integerValue];
        if (state == self.playerState)
            return;
        [self changePlayerState:state];
        self.playerState = state;
    }
}


@end

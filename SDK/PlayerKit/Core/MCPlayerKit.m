//
//  MCPlayerKit.m
//  litttleplayer
//
//  Created by majiancheng on 2017/3/17.
//  Copyright © 2017年 mjc inc. All rights reserved.
//


#import "MCPlayerKit.h"

#import <GCDMulticastDelegate.h>

#import "MCIJKPlayer.h"
#import "MCAVPlayerx.h"
#import "MCPlayerView.h"
#import "MCPlayerKitDef.h"


@interface MCPlayerKit ()

@property(nonatomic, weak) MCPlayerView *playerView;
@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, strong) NSArray<NSString *> *urls;

@property(nonatomic, assign) MCPlayerState playerState;

@property(nonatomic, strong) GCDMulticastDelegate <MCPlayerDelegate> *multicastDelegate;

@end

@implementation MCPlayerKit

- (void)dealloc {
    if(_multicastDelegate) {
        [_multicastDelegate removeAllDelegates];
        _multicastDelegate = nil;
    }
    [self destory];
    MCLog(@"[PK]%@ dealloc", NSStringFromClass(self.class));
}

- (instancetype)initWithPlayerView:(__weak MCPlayerView *)playerView {
    self = [super init];
    if (self) {
        self.playerView = playerView;
        self.playerEnvironment = MCPlayerEnvironmentOnBecomeActiveStatus;
    }
    return self;
}

- (void)updatePlayerView:(MCPlayerView *)playerView {
    self.playerView = playerView;
    self.playerEnvironment = MCPlayerEnvironmentOnBecomeActiveStatus;

    if ([self.multicastDelegate respondsToSelector:@selector(updatePlayView)]) {
        [self.multicastDelegate updatePlayView];
    }
    if ([self.playerView respondsToSelector:@selector(updatePlayerLayer:)] && [_player playerLayer]) {
        [self.playerView updatePlayerLayer:[_player playerLayer]];
    }
    if ([self.playerView respondsToSelector:@selector(updatePlayerView:)] && [_player playerView]) {
        [self.playerView updatePlayerView:[_player playerView]];
    }
}

- (void)addDelegate:(id <MCPlayerDelegate>)multicastDelegate {
    [self.multicastDelegate addDelegate:multicastDelegate delegateQueue:dispatch_get_main_queue()];
}

- (void)removeDelegate:(id <MCPlayerDelegate>)multicastDelegate {
    [self.multicastDelegate removeDelegate:multicastDelegate delegateQueue:dispatch_get_main_queue()];
}

- (void)destory {
    [self fireTimer];
    self.playerState = MCPlayerStateNone;
    if (_player) {
        [_player removeObserver:self forKeyPath:@"playerState"];
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

- (CGFloat)cacheProgress {
    return [_player cacheProgress];
}

- (BOOL)isPlaying {
    return [_player isPlaying];
}

- (void)setActionAtItemEnd:(MCPlayerActionAtItemEnd)actionAtItemEnd {
    _actionAtItemEnd = actionAtItemEnd;
    _player.actionAtItemEnd = actionAtItemEnd;
}

- (void)seekSeconds:(CGFloat)seconds {
    self.playerState = MCPlayerStateBuffering;
    [_player seekSeconds:seconds];
}

- (CGSize)naturalSize {
    return [_player naturalSize];
}

- (BOOL)conditionLimit2CannotPlay {
    if (self.playerEnvironment == MCPlayerEnvironmentOnResignActiveStatus) {
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
    [self.multicastDelegate currentTime:curSecs];
}


- (void)changePlayerState:(MCPlayerState)playerState {
    MCLog(@"PlayerState -> %zd", playerState);
    switch (playerState) {
        case MCPlayerStateLoading : {
            [self timer];
            [self.multicastDelegate playLoading];
        }
            break;
        case MCPlayerStateBuffering: {
            [self.multicastDelegate playBuffer];
        }
            break;
        case MCPlayerStateStarting: {
            [self.multicastDelegate playStart];
            if (self.playerView) {
                [self updatePlayerView:self.playerView];
            }
        }
            break;
        case MCPlayerStatePlaying: {
            [self.multicastDelegate playPlay];
        }
            break;
        case MCPlayerStatePlayEnd: {
            [self.multicastDelegate playEnd];
        }
            break;
        case MCPlayerStateError: {
            [self.multicastDelegate playError];
            [self fireTimer];
        }
            break;
    }
    self.playerState = playerState;
}


#pragma mark - PlayerViewControlDelegate

- (void)playUrls:(nonnull NSArray<NSString *> *)urls {
    [self playUrls:urls isLiveOptions:NO];
}

- (void)playUrls:(nonnull NSArray<NSString *> *)urls isLiveOptions:(BOOL)isLiveOptions {
    [self destory];
    MCLog(@"[Play]%@", urls);
    self.playerState = MCPlayerStateNone;
    self.urls = urls;
    _player = ({
        MCPlayer *player;
        if (self.playerCoreType == MCPlayerCoreIJKPlayer) {
            player = [[MCIJKPlayer alloc] init];
        } else if (self.playerCoreType == MCPlayerCoreAVPlayer) {
            player = [[MCAVPlayerx alloc] init];
        } else {
            player = [[MCIJKPlayer alloc] init];
        }
        player;
    });

    [_player addObserver:self forKeyPath:@"playerState" options:NSKeyValueObservingOptionNew context:nil];
    _player.actionAtItemEnd = self.actionAtItemEnd;
    _player.playerLayerVideoGravity = self.playerLayerVideoGravity;
    [_player playUrls:urls isLiveOptions:isLiveOptions];

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
        MCPlayerState state = (MCPlayerState) [change[NSKeyValueChangeNewKey] integerValue];
        if (state == self.playerState)
            return;
        [self changePlayerState:state];
    }
}

#pragma mark - getter

- (GCDMulticastDelegate <MCPlayerDelegate> *)multicastDelegate {
    if (!_multicastDelegate) {
        _multicastDelegate = (GCDMulticastDelegate <MCPlayerDelegate> *) [GCDMulticastDelegate new];
    }
    return _multicastDelegate;
}

@end

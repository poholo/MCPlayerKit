//
// Created by imooc on 16/5/18.
// Copyright (c) 2016 mjc inc. All rights reserved.
//

#import "Player.h"

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

#import "IJKPlayer.h"
#import "AVPlayerx.h"

@implementation Player

@synthesize playerState = _playerState, cacheProgress = _cacheProgress, rate = _rate, delegate = _delegate;

- (void)dealloc {
    [self releaseSpace];
}

- (void)releaseSpace {
    _delegate = nil;
    [self destory];
}

- (void)enableVideoToolBox:(BOOL)enable {
    _enableVideoToolBox = enable;
}


- (void)playUrls:(nonnull NSArray<NSString *> *)urls {
    [self destory];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}


- (void)playUrls:(nonnull NSArray<NSString *> *)urls isLiveOptions:(BOOL)isLiveOptions {
    [self destory];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}

- (CGFloat)rate {
    return _rate;
}

- (void)preparePlay {
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)play {
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)pause {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (BOOL)isPlaying {
    return NO;
}

- (void)seekSeconds:(CGFloat)seconds {
}


- (void)stop {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)playRate:(CGFloat)playRate {
    _rate = playRate;
}

- (void)destory {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self cancelLoading];
    if ([self playerLayer]) {
        [[self playerLayer] removeFromSuperlayer];
    }
    if (self.playerView) {
        [[self playerView] removeFromSuperview];
    }
}

- (NSTimeInterval)currentTime {
    return 0.0f;
}

- (NSTimeInterval)duration {
    return 0.0f;
}

- (CALayer *)playerLayer {
    return nil;
}

- (UIView *)playerView {
    return nil;
}

- (PlayerCoreType)playerType {
    return PlayerCoreNone;
}

- (NSInteger)currentPlayerItemIndex {
    return NSNotFound;
}

- (BOOL)hasNextVideoItem {
    return NO;
}

- (void)playNextVideoItem {
}

- (void)changePlayerState:(PlayerState)playerState {
    if ([_delegate respondsToSelector:@selector(changePlayerState:)]) {
        [_delegate changePlayerState:playerState];
    }
}

- (void)playFinish {
    if ([_delegate respondsToSelector:@selector(playFinish)]) {
        [_delegate playFinish];
    }
    [self destory];
}

- (void)playError {
    [self destory];
    if ([_delegate respondsToSelector:@selector(playError)]) {
        [_delegate playError];
    }
}

- (void)updatePlayerLayer {
    if ([_delegate respondsToSelector:@selector(updatePlayerLayer)]) {
        [_delegate updatePlayerLayer];
    }

    if ([_delegate respondsToSelector:@selector(adpaterPlayRate)]) {
        [_delegate adpaterPlayRate];
    }
}

- (void)changePlayer:(PlayerCoreType)currentPlayerType {
    if ([_delegate respondsToSelector:@selector(changePlayer:)]) {
        [_delegate changePlayer:currentPlayerType];
    }
}

- (void)cancelLoading {

}

- (void)changeAudioVolume:(CGFloat)volume {
}

- (CGSize)naturalSize {
    return CGSizeZero;
}

@end

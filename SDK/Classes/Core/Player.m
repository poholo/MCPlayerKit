//
// Created by imooc on 16/5/18.
// Copyright (c) 2016 mjc inc. All rights reserved.
//

#import "Player.h"

#import <AudioToolbox/AudioToolbox.h>

@implementation Player

@synthesize playerState = _playerState, cacheProgress = _cacheProgress, rate = _rate;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rate = 1.0f;
        self.playerState = PlayerStateNone;
    }
    return self;
}

- (void)dealloc {
    [self releaseSpace];
}

- (void)releaseSpace {
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
    self.playerState = PlayerStateLoading;
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

- (void)cancelLoading {

}

- (void)changeAudioVolume:(CGFloat)volume {
}

- (CGSize)naturalSize {
    return CGSizeZero;
}

@end

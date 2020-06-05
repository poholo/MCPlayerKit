//
// Created by littleplayer on 16/5/18.
// Copyright (c) 2016 mjc inc. All rights reserved.
//

#import "MCPlayer.h"

#import <AudioToolbox/AudioToolbox.h>

#import "MCPlayerKitDef.h"

@implementation MCPlayer

@synthesize playerState = _playerState, cacheProgress = _cacheProgress, rate = _rate;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rate = 1.0f;
        self.playerState = MCPlayerStateNone;
    }
    return self;
}

- (void)dealloc {
    [self releaseSpace];
    MCLog(@"[MCP][dealloc]%@", [self class]);
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
    self.playerState = MCPlayerStateLoading;
}

- (void)preParePlayContainView:(UIView *)containView {
    self.playerState = MCPlayerStateLoading;
}

- (void)updatePlayerView:(UIView *)playerView {

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

- (MCPlayerCoreType)playerType {
    return MCPlayerCoreNone;
}

- (void)cancelLoading {

}

- (void)changeAudioVolume:(CGFloat)volume {
}

- (CGSize)naturalSize {
    return CGSizeZero;
}

@end

//
// Created by majiancheng on 2017/3/17.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol PlayerViewControlDelegate <NSObject>

@optional

- (void)playUrls:(nonnull NSArray<NSString *> *)urls;

- (void)playUrls:(nonnull NSArray<NSString *> *)urls isLiveOptions:(BOOL)isLiveOptions;

- (void)destory;

- (void)preparePlay;

- (void)play;

- (void)pause;

- (void)cancelLoading;

- (BOOL)isPlaying;

- (void)seekSeconds:(CGFloat)seconds;

- (void)playRate:(CGFloat)playRate;

- (CGFloat)playRate;

- (NSTimeInterval)currentTime; //sec

- (NSTimeInterval)duration;    //sec

- (NSInteger)currentPlayerItemIndex;

- (BOOL)hasNextVideoItem;

- (void)playNextVideoItem;

- (void)changeAudioVolume:(CGFloat)volume;


@end

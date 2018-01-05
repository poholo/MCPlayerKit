//
// Created by imooc on 16/5/20.
// Copyright (c) 2016 mjc inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MCPlayerKit/PlayerConfig.h>


@protocol PlayerTerminalDelegate <NSObject>

@required
- (void)terninalPlayEndReplay;

- (void)terminal3GCanContinuePlay;

- (void)terminalNetErrorRetry;

- (void)terminalUrlErrorRetry;

- (void)terminalErrorRetry;

- (void)terminalShowAirplay2Pause;

- (void)terminalQuitAirplay2Play;

- (void)terminalAirplayPlay;

- (void)terminalAirplayPause;

- (void)terminalAirplayVolumeLarge;

- (void)terminalAirplayVolumeSmall;
@end

@interface PlayerTerminalView : UIView

@property(nonatomic, weak) id <PlayerTerminalDelegate> delegate;

- (void)releaseSpace;

- (void)updatePlayerTerminal:(PlayerState)state title:(NSString *)videoTitle;

@end

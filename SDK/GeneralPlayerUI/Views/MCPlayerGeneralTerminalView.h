//
// Created by littleplayer on 16/5/20.
// Copyright (c) 2016 mjc inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MCPlayerConfig.h"


@protocol PlayerTerminalDelegate <NSObject>

@required
- (void)terminalPlayEndReplay;

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

@interface MCPlayerGeneralTerminalView : UIView

@property(nonatomic, weak) id <PlayerTerminalDelegate> delegate;

- (void)updatePlayerTerminal:(PlayerTerminalState)state title:(NSString *)videoTitle;

@end

//
//  PlayerStatusDelegate.h
//  WaQuVideo
//
//  Created by majiancheng on 2017/3/30.
//  Copyright © 2017年 mjc inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayerStatusDelegate <NSObject>

- (void)playerStartplay;

- (void)playerStartError;

- (void)playerEndplay;

- (void)playEndPause;

- (void)playerEndAutoNext;

- (void)currentTime:(double)time;

- (BOOL)afterSeekNeed2Play;

@end

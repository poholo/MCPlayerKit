//
//  PlayerNextProgressView.h
//  WaQuVideo
//
//  Created by gdb-work on 17/4/18.
//  Copyright © 2017年 mjc inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerConfig.h"

@class MMDto;
@class Video;

#define PROGRESS_WIDTH 44

@protocol PlayerNextProgressViewDelegate <NSObject>

- (void)playerNextProgressViewRelatedPlayVideo:(MMDto *)dto;

- (BOOL)playerNextProgressPlayNext;

@end

@interface PlayerNextProgressView : UIView

@property(nonatomic, copy) void (^progressEndBlock)();
@property(nonatomic, copy) void (^replayBlock)();
@property(nonatomic, copy) void (^backBlock)();
@property(nonatomic, weak) id <PlayerNextProgressViewDelegate> delegate;

@property(nonatomic, strong) Video *currentVideo;

- (instancetype)initWithDuration:(NSNumber *)duration title:(NSString *)title videoPic:(NSString *)videoPic;

- (void)setPlayerStyle:(PlayerStyle)playerStyle;

- (void)updateRalated:(NSArray<MMDto *> *)dtos;

@end

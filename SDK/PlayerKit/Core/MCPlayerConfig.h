//
//  MCPlayerConfig.h
//  litttleplayer
//
//  Created by littleplayer on 16/5/4.
//  Copyright © 2016年 mjc inc. All rights reserved.
//

#import <UIKit/UIKit.h>


/** 默认初始化播放器 */
typedef NS_ENUM(NSInteger, MCPlayerCoreType) {
    MCPlayerCoreIJKPlayer, ///< IJK
    MCPlayerCoreAVPlayer,  ///< AVPlayerx
    MCPlayerCoreNone
};

typedef NS_ENUM(NSInteger, MCPlayerActionAtItemEnd) {
    MCPlayerActionAtItemEndAdvance,
    MCPlayerActionAtItemEndCircle,
    MCPlayerActionAtItemEndNone
};

//播放器播放的几种状态
typedef NS_ENUM(NSInteger, MCPlayerState) {
    MCPlayerStateLoading,
    MCPlayerStateBuffering,  ///< 缓冲中
    MCPlayerStateStarting,   ///< 开始播放
    MCPlayerStatePlaying,    ///< 播放中
    MCPlayerStatePlayEnd,    ///< 播放结束
    MCPlayerStateError,     ///< 播放路径错误
    MCPlayerStateNone,
};

typedef NS_ENUM(NSInteger, MCPlayerTerminalState) {
    MCPlayerTerminalPlayEnd,
    MCPlayerTerminal3GUnenable,
    MCPlayerTerminalNetError,
    MCPlayerTerminalUrlError,
    MCPlayerTerminalError
};

/***
 * 播放器渲染模式
 */
typedef NS_ENUM(NSInteger, MCPlayerLayerVideoGravity) {
    MCPlayerLayerVideoGravityResizeAspect,
    MCPlayerLayerVideoGravityResizeAspectFill,
    MCPlayerLayerVideoGravityResize,
};

/** 播放器现在环境 */
typedef NS_ENUM(NSInteger, MCPlayerEnvironment) {
    MCPlayerEnvironmentOnResignActiveStatus,
    MCPlayerEnvironmentOnBecomeActiveStatus,
};

//////////////////////AVPlayerKVO///////////////////////////////////////////
extern NSString *const _kMC_Player_ExternalPlayBackActive;
extern NSString *const _kMC_Player_Status;
extern NSString *const _kMC_Player_CurrentItem;

//////////////////////AVPlayerItem//////////////////////////////////////////////////////
extern NSString *const _kMC_PlayerItem_Status;
extern NSString *const _kMC_PlayerItem_PlaybackBufferEmpty;
extern NSString *const _kMC_PlayerItem_PlaybackLikelyToKeepUp;
extern NSString *const _kMC_PlayerItem_LoadedTimeRanges;

@interface MCPlayerConfig : NSObject

@end

//
//  MCPlayerConfig.h
//  litttleplayer
//
//  Created by littleplayer on 16/5/4.
//  Copyright © 2016年 mjc inc. All rights reserved.
//

#import <UIKit/UIKit.h>


/** 默认初始化播放器 */
typedef NS_ENUM(NSInteger, PlayerCoreType) {
    PlayerCoreIJKPlayer, ///< IJK
    PlayerCoreAVPlayer,  ///< AVPlayerx
    PlayerCoreNone
};

typedef NS_ENUM(NSInteger, PlayerActionAtItemEnd) {
    PlayerActionAtItemEndAdvance,
    PlayerActionAtItemEndCircle,
    PlayerActionAtItemEndNone
};

//播放器播放的几种状态
typedef NS_ENUM(NSInteger, PlayerState) {
    PlayerStateLoading,
    PlayerStateBuffering,  ///< 缓冲中
    PlayerStateStarting,   ///< 开始播放
    PlayerStatePlaying,    ///< 播放中
    PlayerStatePlayEnd,    ///< 播放结束
    PlayerStateError,     ///< 播放路径错误
    PlayerStateNone,
};

/***
 * 播放器渲染模式
 */
typedef NS_ENUM(NSInteger, PlayerLayerVideoGravity) {
    PlayerLayerVideoGravityResizeAspect,
    PlayerLayerVideoGravityResizeAspectFill,
    PlayerLayerVideoGravityResize,
};

/** 播放器现在环境 */
typedef NS_ENUM(NSInteger, PlayerEnvironment) {
    PlayerEnvironmentOnResignActiveStatus,
    PlayerEnvironmentOnBecomeActiveStatus,
};

//////////////////////AVPlayerKVO///////////////////////////////////////////
extern NSString *const _k_Player_ExternalPlayBackActive;
extern NSString *const _k_Player_Status;
extern NSString *const _k_Player_CurrentItem;

//////////////////////AVPlayerItem//////////////////////////////////////////////////////
extern NSString *const _k_PlayerItem_Status;
extern NSString *const _k_PlayerItem_PlaybackBufferEmpty;
extern NSString *const _k_PlayerItem_PlaybackLikelyToKeepUp;
extern NSString *const _k_PlayerItem_LoadedTimeRanges;

@interface MCPlayerConfig : NSObject

@end

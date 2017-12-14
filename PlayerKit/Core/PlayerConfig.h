//
//  PlayerConfig.h
//  WaQuVideo
//
//  Created by imooc on 16/5/4.
//  Copyright © 2016年 mjc inc. All rights reserved.
//

#import <UIKit/UIKit.h>


/** 默认初始化播放器 */
typedef NS_ENUM(NSInteger, PlayerCoreType) {
    PlayerCoreIJKPlayer, ///< IJK
    PlayerCoreAVPlayer,    ///< AVPlayerx
    PlayerCoreNone
};

typedef NS_ENUM(NSInteger, PlayerActionAtItemEnd) {
    PlayerActionAtItemEndAdvance,
    PlayerActionAtItemEndPause,
    PlayerActionAtItemEndCircle,
    PlayerActionAtItemEndNone
};

//播放器展示形态
typedef NS_ENUM(NSInteger, PlayerStyle) {
    PlayerStyleSizeClassRegularHalf,   ///<  16:9 半屏幕
    PlayerStyleSizeClassRegular,       ///<  竖屏全屏
    PlayerStyleSizeClassCompact,        ///<  横屏全屏
    PlayerStyleSizeRegularAuto
};


//播放器播放的几种状态
typedef NS_ENUM(NSInteger, PlayerState) {
    PlayerStateNone,
    PlayerStateLoading,
    PlayerStateLoadingNoBg,///< 无背景loading
    PlayerStateBuffering,  ///< 缓冲中
    PlayerStateStarting,   ///< 开始播放
    PlayerStatePlaying,    ///< 播放中
    PlayerStatePlayEnd,       ///< 播放结束
    PlayerStatePausing,    ///< 暂停
    PlayerStateStopped,    ///< 停止播放
    PlayerState3GUnenable, ///< 不允许3g播放
    PlayerStateNetError,  ///< 播放错误[网络]
    PlayerStateUrlError,  ///< 播放路径错误
    PlayerStateError,     ///< 播放路径错误
};

/** 播放器现在环境 */
typedef NS_ENUM(NSInteger, PlayerEnvironment) {
    PlayerEnvironmentOnResignActiveStatus,
    PlayerEnvironmentOnBecomeActiveStatus,
};

typedef NS_ENUM(NSInteger, PlayerUserStatus) {
    PlayerUserAutoStatus,
    PlayerUserPauseStatus,
    PlayerUserAirplayStatus
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

@interface PlayerConfig : NSObject

+ (instancetype)sharedPlayerConfig;

@end

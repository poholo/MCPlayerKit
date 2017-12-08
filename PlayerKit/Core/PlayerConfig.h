//
//  PlayerConfig.h
//  WaQuVideo
//
//  Created by imooc on 16/5/4.
//  Copyright © 2016年 mjc inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IJKTEST 0
#define PlayerBoundaryTest 0

typedef void (^CallBackTwo)(id value0, id value1);

typedef void (^CallBackOne)(id value);

typedef void (^CallbackNone)();

typedef void (^CallbackFinish)(BOOL finish, id value);

/** 默认初始化播放器 */
typedef NS_ENUM(NSInteger, PlayerCoreType) {
    PlayerCoreIJKPlayer, ///< IJK
    PlayerCoreAVPlayer,    ///< AVPlayerx
    PlayerCoreNone
};


typedef NS_ENUM(NSInteger, PlayerActionAtItemEnd) {
    PlayerActionAtItemEndAdvance = 0,
    PlayerActionAtItemEndPause = 1,
    PlayerActionAtItemEndCircle = 2,
    PlayerActionAtItemEndNone = 3,
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
    PlayerStatePlayEndByNext, ///< 播放结束（切换下一个）
    PlayerStatePlayEndByPre,  ///< 播放结束（切换上一个）
    PlayerStatePausing,    ///< 暂停
    PlayerStateStopped,    ///< 停止播放
    PlayerState3GUnenable, ///< 不允许3g播放
    PlayerStateNetError,  ///< 播放错误[网络]
    PlayerStateUrlError,  ///< 播放路径错误
    PlayerStateError,     ///< 播放路径错误
    PlayerPlayingUsingAirplay  ///< 用airplay播放暂停
};

//播放器展示形态
typedef NS_ENUM(NSInteger, PlayerStyle) {
    PlayerStyleSizeClassRegularHalf,   ///<  16:9 半屏幕
    PlayerStyleSizeClassRegular,       ///<  竖屏全屏
    PlayerStyleSizeClassCompact,        ///<  横屏全屏
    PlayerStyleSizeRegularAuto
};

typedef NS_ENUM(NSInteger, VideoSourceCardType) {
    VideoSourceNormal,   ///<  常规趣单进入
    VideoSourceSearch,       ///<  来自搜索
    VideoSourceDownload        ///<  来自下载
};

typedef NS_ENUM(NSInteger, PlayerType) {
    PlayerNormal,                  ///<  普通播放器
    PlayerAd,
    PlayerBaiduAd
};

typedef NS_ENUM(NSInteger, RecordType) {
    RecordNormal = -1,
    RecordCompile = 0
};


/** 暂停播放的可能状态  */
typedef NS_ENUM(NSInteger, WQPlayerPauseState) {
    WQPlayerNoPause,               ///< 未暂停
    WQPlayerPauseDefault,          ///< 默认值
    WQPlayerPauseByNetBad,         ///< 网络查暂停
    WQPlayerPauseByEnterBack,      ///< 进入后台暂停
    WQPlayerPauseByShared,         ///< 分享暂停
    WQPlayerPauseByUser,           ///< 用户手动暂停
    WQPlayerPauseByEnterInNewPage,  ///< 进入新的page暂停
    WQPlayerPauseBy3GCannotPlay,     ///< 3G不允许播放
    WQPlayerPauseByNetError,
    WQPlayerPauseWhenOutHeadPhone,   ///< 耳机
    WQPlayerPauseWhenUsingAirplay

};


typedef NS_ENUM(NSInteger, PlayerRoateType) {
    PlayerRotating,
    PlayerNotRotateShowSharedBoard,
    PlayerNotRotateShowCommentView,
    PlayerNotRotateShowFollowBoard,
    PlayerNotRotateShowAirplayView
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

typedef NS_ENUM(NSInteger, DefinitionType) {
    DTNormal,   ///< 标清
    DTHight,    ///< 高清
    DTUHight    ///< 超清
};

typedef NS_ENUM(NSInteger, PlayerLayerLevel) {
    PlayerLayerLevelBase = 0,
    PlayerLayerLevelDrawmap0,
    PlayerLayerLevelDefaultBgView,
    PlayerLayerLevelDrawmap1,
    PlayerLayerLevelTouchView,
    PlayerLayerLevelWater,
    PlayerLayerLevelControlBar,
    PlayerLayerLevelNormalControlBar,
    PlayerLayerLevelPlayerRate,
    PlayerLayerLevelAdView,
    PlayerLayerLevelLoadingView,
    PlayerLayerLevelTerminal,
    PlayerLayerLevelBackView,
    PlayerLayerLevelFollowView
};

typedef NS_ENUM(NSInteger, PlayErrorRetryType) {
    PlayErrorRetryNone,
    PlayErrorRetryAVPlayerx,
    PlayErrorRetryAVPlayerxRetryUrls,
    PlayErrorRetryIJKPlayer,
    PlayErrorRetryIJKPlayerRetryUrls,
    PlayErrorRetryCannotPlay
};


typedef NS_ENUM(NSInteger, AudioModeType) {
    AudioModeSpeaker, ///< 扬声器
    AudioModeHead         ///< 带线耳机
};


@interface PlayerConfig : NSObject

/** 颜色 */
#define _k_AV_default_bgcolor [UIColor blackColor]

/** 字体大小 */
extern CGFloat const _k_AV_font_normal;
extern CGFloat const _k_AV_font_title;

/** 播放器尺寸*/
extern CGFloat const _k_AV_TopBar_height;
extern CGFloat const _k_AV_ControlBar_height;

extern CGFloat const _k_AV_WillHideTime;

extern NSString *const _k_AV_Loading_image;                                                  ///< 背景默认图
extern NSString *const _k_AV_loading_default_image;                                          ///< Loading旋转图
extern NSString *const _k_AV_water_image;
extern NSString *const _k_AV_water_land_image;
extern CGFloat const _k_AV_offsetChoseDirection;


extern NSString *const _k_AV_TerminalMentionPLayerStatePlayEnd;
extern NSString *const _k_AV_TerminalMentionPlayerState3GUnenable;
extern NSString *const _k_AV_TerminalMentionPlayerStateNetError;
extern NSString *const _k_AV_TerminalMentionPlayerStateUrlError;
extern NSString *const _k_AV_TerminalMentionPlayerStateError;
extern NSString *const _k_AV_TermianlMentionPlayerAirplaying;

/////////////////////////Topbar//////////////////////////////////
extern NSString *const _k_AV_TopBarBtnShareNormalImageName;
extern NSString *const _k_AV_TopBarBtnDownloadNormalImageName;
extern NSString *const _k_AV_TopBarBtnCollectNormalImageName;
extern NSString *const _k_AV_TopBarBtnLoopNormalImageName;
extern NSString *const _k_AV_TopBarBtnPlayRateNormalImageName;

extern NSString *const _k_AV_TopBarBtnCollectSelectedImageName;
extern NSString *const _k_AV_TopBarBtnLoopSelectedImageName;
extern NSString *const _k_AV_TopBarBtnPlayRateSelectedImageName;

/////////////////////Toast///////////////////////////////////////
extern NSString *const _k_AV_NO_PreVideoMes;
extern NSString *const _k_AV_NO_NextVideoMes;

/////////////////////////////////////////////////////////////////
extern NSString *const _k_DT_Normal_name;
extern NSString *const _k_DT_HD_name;
extern NSString *const _k_DT_UHD_name;

//////////////////////AVPlayerKVO///////////////////////////////////////////
extern NSString *const _k_Player_ExternalPlayBackActive;
extern NSString *const _k_Player_Status;
extern NSString *const _k_Player_CurrentItem;

//////////////////////AVPlayerItem//////////////////////////////////////////////////////
extern NSString *const _k_PlayerItem_Status;
extern NSString *const _k_PlayerItem_PlaybackBufferEmpty;
extern NSString *const _k_PlayerItem_PlaybackLikelyToKeepUp;
extern NSString *const _k_PlayerItem_LoadedTimeRanges;

/////////////////////player_type//////////////////////////////////////
extern NSString *const _k_player_WQAVPlayer;
extern NSString *const _k_player_IJKPlayer;

+ (instancetype)sharedPlayerConfig;

- (void)showPlayerDebugMenu;

- (void)hidenDebugMenu;

@end

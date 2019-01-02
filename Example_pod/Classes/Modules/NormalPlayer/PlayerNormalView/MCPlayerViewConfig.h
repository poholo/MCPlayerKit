//
// Created by majiancheng on 2017/12/12.
// Copyright (c) 2017 majiancheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSInteger, DefinitionType) {
    DTNormal,   ///< 标清
    DTHight,    ///< 高清
    DTUHight    ///< 超清
};

typedef NS_ENUM(NSInteger, PlayerType) {
    PlayerNormal,                  ///<  普通播放器
    PlayerAd,
    PlayerUnionAd
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

/////////////////////player_type//////////////////////////////////////
extern NSString *const _k_player_WQAVPlayer;
extern NSString *const _k_player_IJKPlayer;

typedef void(^MCPlayerNormalViewEventCallBack)(NSString *action, id value);

@interface MCPlayerViewConfig : NSObject

@property(nonatomic, assign) DefinitionType definitionType;

+ (instancetype)sharedInstance;


+ (UIColor *)colorI;

+ (UIColor *)colorII;

+ (UIColor *)colorIII;

+ (UIColor *)colorIV;

+ (UIColor *)colorV;

+ (UIColor *)colorVI;

+ (UIColor *)colorVII;

@end

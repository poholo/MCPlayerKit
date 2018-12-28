//
// Created by majiancheng on 2017/12/12.
// Copyright (c) 2017 majiancheng. All rights reserved.
//

#import "MCPlayerViewConfig.h"
#import "MMPopupCategory.h"


/** 字体大小 */
CGFloat const _k_AV_font_normal = 12.0f;
CGFloat const _k_AV_font_title = 15.0f;


CGFloat const _k_AV_TopBar_height = 40.0f;
CGFloat const _k_AV_ControlBar_height = 44.0f;

CGFloat const _k_AV_WillHideTime = 4.0f;

NSString *const _k_AV_Loading_image = @"player_loading_pic";
NSString *const _k_AV_loading_default_image = @"ic_play_loading";
NSString *const _k_AV_water_image = @"play_portrait_logo";
NSString *const _k_AV_water_land_image = @"play_landscape_logo";

CGFloat const _k_AV_offsetChoseDirection = 8.0;

NSString *const _k_AV_TerminalMentionPLayerStatePlayEnd = @"点击重新播放";
NSString *const _k_AV_TerminalMentionPlayerState3GUnenable = @"当前是移动网络,继续播放将产生流量,点击继续播放";
NSString *const _k_AV_TerminalMentionPlayerStateNetError = @"网络连接错误,点击重试";
NSString *const _k_AV_TerminalMentionPlayerStateUrlError = @"视频播放错误,点击重试";
NSString *const _k_AV_TerminalMentionPlayerStateError = @"播放失败,请稍后再试";
NSString *const _k_AV_TermianlMentionPlayerAirplaying = @"正在使用Airplay播放, 点击退出";;

/////////////////////////Topbar//////////////////////////////////
NSString *const _k_AV_TopBarBtnShareNormalImageName = @"ic_share_white";
NSString *const _k_AV_TopBarBtnDownloadNormalImageName = @"ic_save_white";
NSString *const _k_AV_TopBarBtnCollectNormalImageName = @"ic_favorite_white";
NSString *const _k_AV_TopBarBtnLoopNormalImageName = @"ic_loop_white";
NSString *const _k_AV_TopBarBtnPlayRateNormalImageName = @"ic_slow_white";

NSString *const _k_AV_TopBarBtnCollectSelectedImageName = @"ic_favorited";
NSString *const _k_AV_TopBarBtnLoopSelectedImageName = @"ic_unloop_white";
NSString *const _k_AV_TopBarBtnPlayRateSelectedImageName = @"ic_normal_white";

/////////////////////Toast///////////////////////////////////////
NSString *const _k_AV_NO_PreVideoMes = @"没有上一个视频";
NSString *const _k_AV_NO_NextVideoMes = @"没有下一个视频";

/////////////////////////////////////////////////////////////////
NSString *const _k_DT_Normal_name = @"sd";
NSString *const _k_DT_HD_name = @"hd";
NSString *const _k_DT_UHD_name = @"hd2";

//////////////////////player_type//////////////////////////////////////
NSString *const _k_player_WQAVPlayer = @"WQAVPlayer";
NSString *const _k_player_IJKPlayer = @"ijkplay";

@implementation MCPlayerViewConfig {

}

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static MCPlayerViewConfig *config;
    dispatch_once(&once, ^{
        config = [[[self class] alloc] init];
    });
    return config;
}

+ (UIColor *)colorI {
    return [MCPlayerViewConfig colorWithHex:0xffffff];
}

+ (UIColor *)colorII {
    return[MCPlayerViewConfig colorWithHex:0xffffff];
}

+ (UIColor *)colorIII {
    return [MCPlayerViewConfig colorWithHex:0xffffff];
}

+ (UIColor *)colorIV {
    return [MCPlayerViewConfig colorWithHex:0x5cc0f2];
}

+ (UIColor *)colorV {
    return [MCPlayerViewConfig colorWithHex:0x232629];
}

+ (UIColor *)colorVI {
    return [MCPlayerViewConfig colorWithHex:0x737b80];
}

+ (UIColor *)colorVII {
    return [MCPlayerViewConfig colorWithHex:0x97a2a8];
}

+ (UIColor *)colorWithHex:(NSUInteger)hex {

    float r = (hex & 0xff000000) >> 24;
    float g = (hex & 0x00ff0000) >> 16;
    float b = (hex & 0x0000ff00) >> 8;
    float a = (hex & 0x000000ff);

    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a / 255.0f];
}

@end

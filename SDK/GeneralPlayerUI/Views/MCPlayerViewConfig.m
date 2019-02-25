//
// Created by majiancheng on 2017/12/12.
// Copyright (c) 2017 majiancheng. All rights reserved.
//

#import "MCPlayerViewConfig.h"


CGFloat const  _kMC_AV_offsetChoseDirection = 8.0;

NSString *const _kMC_AV_TerminalMentionPlayerStatePlayEnd = @"点击重新播放";
NSString *const _kMC_AV_TerminalMentionPlayerState3GUnenable = @"当前是移动网络,继续播放将产生流量,点击继续播放";
NSString *const _kMC_AV_TerminalMentionPlayerStateNetError = @"网络连接错误,点击重试";
NSString *const _kMC_AV_TerminalMentionPlayerStateUrlError = @"视频播放错误,点击重试";
NSString *const _kMC_AV_TerminalMentionPlayerStateError = @"播放失败,请稍后再试";
NSString *const _kMC_AV_TermianlMentionPlayerAirplaying = @"正在使用Airplay播放, 点击退出";;

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

@end

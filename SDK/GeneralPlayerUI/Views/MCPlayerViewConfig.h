//
// Created by majiancheng on 2017/12/12.
// Copyright (c) 2017 majiancheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSInteger, MCDefinitionType) {
    MCDefinitionNormal,   ///< 标清
    MCDefinitionHight,    ///< 高清
    MCDefinitionUHight    ///< 超清
};


extern CGFloat const _kMC_AV_offsetChoseDirection;
extern NSString *const _kMC_AV_TerminalMentionPlayerStatePlayEnd;
extern NSString *const _kMC_AV_TerminalMentionPlayerState3GUnenable;
extern NSString *const _kMC_AV_TerminalMentionPlayerStateNetError;
extern NSString *const _kMC_AV_TerminalMentionPlayerStateUrlError;
extern NSString *const _kMC_AV_TerminalMentionPlayerStateError;
extern NSString *const _kMC_AV_TermianlMentionPlayerAirplaying;

typedef id(^MCPlayerNormalViewEventCallBack)(NSString *action, id value);

@interface MCPlayerViewConfig : NSObject

@property(nonatomic, assign) MCDefinitionType definitionType;

+ (instancetype)sharedInstance;


@end

//
// Created by majiancheng on 2017/3/17.
// Copyright (c) 2017 mjc inc. All rights reserved.
//



#import "MCPlayerBaseView.h"

#import "MCPlayerViewConfig.h"


extern NSString *const kMCPlayer2PlayAction;
extern NSString *const kMCPlayer2PauseAction;

typedef NS_ENUM(NSInteger, MCPlayerStyleSizeType) {
    PlayerStyleSizeClassRegularHalf,   ///<  16:9 半屏幕
    PlayerStyleSizeClassRegular,       ///<  竖屏全屏
    PlayerStyleSizeClassCompact        ///<  横屏全屏
};

/***
 * 通用播放器view
 */
@interface MCPlayerNormalView : UIView

@property(nonatomic, assign) MCPlayerStyleSizeType styleSizeType;
@property(nonatomic, copy) MCPlayerNormalViewEventCallBack eventCallBack;
@property(nonatomic, readonly) MCPlayerBaseView *playerView;

- (void)updatePlayerStyle:(MCPlayerStyleSizeType)styleSizeType;

- (void)updateTitle:(NSString *)title;

- (void)currentTime:(double)time;

- (void)duration:(double)time;

- (BOOL)isLock;

@end

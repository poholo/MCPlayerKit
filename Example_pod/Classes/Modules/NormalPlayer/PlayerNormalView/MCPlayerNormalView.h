//
// Created by majiancheng on 2017/3/17.
// Copyright (c) 2017 mjc inc. All rights reserved.
//



#import "MCPlayerBaseView.h"

#import "MCPlayerViewConfig.h"


typedef NS_ENUM(NSInteger, MCPlayerStyleSizeType) {
    PlayerStyleSizeClassRegularHalf,   ///<  16:9 半屏幕
    PlayerStyleSizeClassRegular,       ///<  竖屏全屏
    PlayerStyleSizeClassCompact        ///<  横屏全屏
};

/***
 * 通用播放器view
 */
@interface MCPlayerNormalView : UIView

@property(nonatomic, copy) MCPlayerNormalViewEventCallBack eventCallBack;
@property(nonatomic, readonly) MCPlayerBaseView *playerView;

- (void)updatePlayerStyle:(MCPlayerStyleSizeType)styleSizeType;

- (void)updateTitle:(NSString *)title;


@end

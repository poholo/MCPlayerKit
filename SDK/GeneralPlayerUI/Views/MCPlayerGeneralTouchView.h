//
// Created by majiancheng on 2018/12/29.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MCPlayerViewConfig.h"

/**
 * 管理播放器UI触摸事件
 */

extern NSString *const kMCTouchTapAction;
extern NSString *const kMCTouchBegin;
extern NSString *const kMCTouchSeekAction;
extern NSString *const kMCTouchCurrentTimeAction;
extern NSString *const kMCTouchDurationAction;

@interface MCPlayerGeneralTouchView : UIView

@property(nonatomic, copy) MCPlayerNormalViewEventCallBack callBack;
@property(nonatomic, assign) BOOL unableSeek;

@end
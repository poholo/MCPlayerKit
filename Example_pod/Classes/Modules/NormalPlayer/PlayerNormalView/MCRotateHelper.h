//
// Created by majiancheng on 2019/1/2.
// Copyright (c) 2019 majiancheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCRotateHelper : NSObject

+ (void)setStatusBarHidden:(BOOL)isHidden;

/**
 * 设置横竖屏
 */
+ (void)updatePlayerRegularHalf;

/**
 * 竖屏时切换成横屏
 */
+ (void)updatePlayerRegular;

/**
 * 横屏时切换竖屏
 */
+ (void)updatePlayerCompact;

@end
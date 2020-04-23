//
// Created by majiancheng on 2018/12/28.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MCPlayerGeneralView.h"

@class MCCustomActionView;

extern NSString *const kMCPlayerHeaderBack;

@interface MCPlayerGeneralHeader : UIView

@property(nonatomic, readonly) UILabel *titleLabel;

@property(nonatomic, readonly) MCCustomActionView *rightView;

@property(nonatomic, copy) MCPlayerNormalViewEventCallBack callBack;

@property(nonatomic, assign) BOOL notTop;

- (void)updatePlayerStyle:(MCPlayerStyleSizeType)styleSizeType;

- (void)fadeHiddenControl;

- (void)showControl;

@end

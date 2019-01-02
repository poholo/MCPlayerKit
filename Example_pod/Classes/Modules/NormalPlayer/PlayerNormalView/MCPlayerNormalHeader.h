//
// Created by majiancheng on 2018/12/28.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MCPlayerNormalView.h"

extern NSString *const kMCPlayerHeaderBack;
extern NSString *const kMCPlayerHeaderBack2Half;

@interface MCPlayerNormalHeader : UIView

@property(nonatomic, readonly) UILabel *titleLabel;

@property(nonatomic, copy) MCPlayerNormalViewEventCallBack callBack;

- (void)updatePlayerStyle:(MCPlayerStyleSizeType)styleSizeType;

- (NSInteger)top;

@end
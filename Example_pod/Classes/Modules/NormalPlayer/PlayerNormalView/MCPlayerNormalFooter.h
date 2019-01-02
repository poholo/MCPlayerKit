//
// Created by majiancheng on 2018/12/28.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCPlayerNormalView.h"

@class MCPlayerProgress;

@interface MCPlayerNormalFooter : UIView

@property(nonatomic, copy) MCPlayerNormalViewEventCallBack callBack;

- (void)updatePlayerStyle:(MCPlayerStyleSizeType)styleSizeType;

@end
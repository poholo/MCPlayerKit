//
// Created by majiancheng on 2019/1/22.
// Copyright (c) 2019 majiancheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCPlayerGeneralView.h"

@class MCPlayerCommonButton;

@interface MCCustomActionView : UIView


- (void)addSubview:(UIView *)view NS_UNAVAILABLE;

- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview NS_UNAVAILABLE;

- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview NS_UNAVAILABLE;

- (void)addCustom:(MCPlayerCommonButton *)customView;

- (void)resizeViews;

- (void)updatePlayerStyle:(MCPlayerStyleSizeType)styleSizeType;

@end
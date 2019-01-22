//
// Created by majiancheng on 2019/1/22.
// Copyright (c) 2019 majiancheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCPlayerCommonButton : UIButton

@property(nonatomic, assign) NSInteger tag;  ///< giv index, sort by index 从左向右
@property(nonatomic, assign) CGSize size;   ///< view内容区域大小
@property(nonatomic, assign) BOOL showHalfScreen; ///< 半个屏幕是否展现, default YES
@property(nonatomic, assign) BOOL showFullScreen; ///< 全屏是否展现, default YES

@end
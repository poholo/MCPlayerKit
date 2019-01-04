//
//  MCCircleProgress.h
//  DrewTest
//
//  Created by majiancheng on 2017/3/17.
//  Copyright © 2017年 poholo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCCircleProgress : UIView

@property(nonatomic, strong) UIColor *trackColor;
@property(nonatomic, strong) UIColor *progressColor;

@property(nonatomic, assign) CGFloat lineWidth;

@property(nonatomic, assign) NSInteger seconds; //s
@property(nonatomic, assign) CGFloat rate;
@property(nonatomic, assign) BOOL repeat;

- (void)start;

- (void)pause;

- (void)resume;

- (void)stop;

@end

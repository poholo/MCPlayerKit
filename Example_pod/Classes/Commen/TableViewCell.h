//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Dto;


@interface TableViewCell : UITableViewCell

- (void)loadData:(Dto *)dto;

+ (NSString *)identifier;

+ (CGFloat)height;

@end
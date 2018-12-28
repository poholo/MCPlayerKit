//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "Dto.h"


@interface PlayerNormalDto : Dto

@property(nonatomic, strong) NSString *name;

@property(nonatomic, assign) CGSize playerSize;

@end
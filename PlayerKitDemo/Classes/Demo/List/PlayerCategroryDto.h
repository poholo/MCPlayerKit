//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "Dto.h"

@protocol MCControllerProtocol;


@interface PlayerCategroryDto : Dto

@property(nonatomic, strong) NSString *name;

@property(nonatomic, strong) NSString *info;

@property(nonatomic, assign) Class actionClass;

@end

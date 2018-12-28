//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Dto;


@interface DataVM : NSObject

@property(nonatomic, strong) NSMutableArray<Dto *> *dataList;

- (void)refresh;


@end
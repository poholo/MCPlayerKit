//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataVM;

@protocol MCControllerProtocol <NSObject>

@property(nonatomic, strong) DataVM *dataVM;

- (instancetype)initWithParams:(NSDictionary *)params;

@end
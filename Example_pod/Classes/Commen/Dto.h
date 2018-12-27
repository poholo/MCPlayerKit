//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * base model
 */
@interface Dto : NSObject

@property(nonatomic, strong) NSString *entityId;

+ (id)createDto:(NSDictionary *)dictionary;

@end
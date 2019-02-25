//
// Created by majiancheng on 2017/12/11.
// Copyright (c) 2017 majiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (MCExtend)

+ (NSURL *)source4URI:(NSString *)uri;

+ (void)__openURL:(NSURL*)url completionHandler:(void (^ __nullable)(BOOL success))completion;

@end
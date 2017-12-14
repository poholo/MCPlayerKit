//
// Created by majiancheng on 2017/12/14.
// Copyright (c) 2017 majiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * from ijk
 */
@interface SafeNotificationManager : NSObject

- (void)addObserver:(nonnull id)observer selector:(nonnull SEL)aSelector name:(nullable NSString *)aName object:(nullable id)anObject;

- (void)removeAllObservers:(nonnull id)observer;

@end
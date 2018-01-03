//
// Created by majiancheng on 2017/12/14.
// Copyright (c) 2017 majiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

/***
 * from ijk
 */
@interface SafeKVOController : NSObject

- (id)initWithTarget:(NSObject *)target;

- (void)safelyAddObserver:(NSObject *)observer
               forKeyPath:(NSString *)keyPath
                  options:(NSKeyValueObservingOptions)options
                  context:(void *)context;

- (void)safelyRemoveObserver:(NSObject *)observer
                  forKeyPath:(NSString *)keyPath;

- (void)safelyRemoveAllObservers;

@end
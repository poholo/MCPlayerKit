//
// Created by majiancheng on 2017/12/14.
// Copyright (c) 2017 majiancheng. All rights reserved.
//

#import "MCSafeKVOController.h"

@interface MCKVOEntry : NSObject
@property(nonatomic, weak) NSObject *observer;
@property(nonatomic, strong) NSString *keyPath;
@end

@implementation MCKVOEntry
@synthesize observer;
@synthesize keyPath;
@end


@implementation MCSafeKVOController {
    __weak NSObject *_target;
    NSMutableArray *_observerArray;
}

- (id)initWithTarget:(NSObject *)target {
    self = [super init];
    if (self) {
        _target = target;
        _observerArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)safelyAddObserver:(NSObject *)observer
               forKeyPath:(NSString *)keyPath
                  options:(NSKeyValueObservingOptions)options
                  context:(void *)context {
    NSObject *target = _target;
    if (target == nil)
        return;

    BOOL removed = [self removeEntryOfObserver:observer forKeyPath:keyPath];
    if (removed) {
        // duplicated register
        NSLog(@"duplicated observer");
    }

    @try {
        [target addObserver:observer
                 forKeyPath:keyPath
                    options:options
                    context:context];

        MCKVOEntry *entry = [[MCKVOEntry alloc] init];
        entry.observer = observer;
        entry.keyPath = keyPath;
        [_observerArray addObject:entry];
    } @catch (NSException *e) {
        NSLog(@"IJKKVO: failed to add observer for %@\n", keyPath);
    }
}

- (void)safelyRemoveObserver:(NSObject *)observer
                  forKeyPath:(NSString *)keyPath {
    NSObject *target = _target;
    if (target == nil)
        return;

    BOOL removed = [self removeEntryOfObserver:observer forKeyPath:keyPath];
    if (removed) {
        // duplicated register
        NSLog(@"duplicated observer");
    }

    @try {
        if (removed) {
            [target removeObserver:observer
                        forKeyPath:keyPath];
        }
    } @catch (NSException *e) {
        NSLog(@"IJKKVO: failed to remove observer for %@\n", keyPath);
    }
}

- (void)safelyRemoveAllObservers {
    __block NSObject *target = _target;
    if (target == nil)
        return;

    [_observerArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MCKVOEntry *entry = obj;
        if (entry == nil)
            return;

        NSObject *observer = entry.observer;
        if (observer == nil)
            return;

        @try {
            [target removeObserver:observer
                        forKeyPath:entry.keyPath];
        } @catch (NSException *e) {
            NSLog(@"IJKKVO: failed to remove observer for %@\n", entry.keyPath);
        }
    }];

    [_observerArray removeAllObjects];
}

- (BOOL)removeEntryOfObserver:(NSObject *)observer
                   forKeyPath:(NSString *)keyPath {
    __block NSInteger foundIndex = -1;
    [_observerArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MCKVOEntry *entry = (MCKVOEntry *) obj;
        if (entry.observer == observer &&
                [entry.keyPath isEqualToString:keyPath]) {
            foundIndex = idx;
            *stop = YES;
        }
    }];

    if (foundIndex >= 0) {
        [_observerArray removeObjectAtIndex:foundIndex];
        return YES;
    }

    return NO;
}
@end
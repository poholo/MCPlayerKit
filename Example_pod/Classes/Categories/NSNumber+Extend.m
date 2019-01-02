//
// Created by majiancheng on 2019/1/2.
// Copyright (c) 2019 majiancheng. All rights reserved.
//

#import "NSNumber+Extend.h"


@implementation NSNumber (Extend)

- (NSString *)hhMMss {
    NSInteger duration = self.integerValue;
    long long hour = duration / 3600;
    long long minute = duration / 60;
    long long second = duration % 60;
    NSString *hhMMss = nil;
    if (hour > 0) {
        hhMMss = [NSString stringWithFormat:@"%lld:%02lld:%02lld", hour, minute - hour * 60, second];
    } else {
        hhMMss = [NSString stringWithFormat:@"%02lld:%02lld", minute, second];
    }
    return hhMMss;
}

@end
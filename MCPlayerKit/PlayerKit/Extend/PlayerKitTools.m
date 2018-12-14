//
// Created by majiancheng on 2017/12/11.
// Copyright (c) 2017 majiancheng. All rights reserved.
//

#import "PlayerKitTools.h"


@implementation PlayerKitTools

+ (NSString *)secondTimeString:(long long)sec {
    NSString *videoDur = nil;
    long long hour = sec / 3600;
    long long minute = sec / 60;
    long long second = sec % 60;
    if (hour > 0) {
        videoDur = [NSString stringWithFormat:@"%lld:%02lld:%02lld", hour, minute - hour * 60, second];
    } else {
        videoDur = [NSString stringWithFormat:@"%02lld:%02lld", minute, second];
    }
    return [videoDur copy];
}

@end
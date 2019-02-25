//
// Created by majiancheng on 2019/1/2.
// Copyright (c) 2019 majiancheng. All rights reserved.
//

#import "NSNumber+MCExtend.h"


@implementation NSNumber (MCExtend)

- (NSString *)hhMMss {
    static NSDateFormatter *formatter = nil;
    NSInteger duration = self.integerValue;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:duration];
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    if (duration >= 3600) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *string = [formatter stringFromDate:date];
    return string;
}

@end
//
// Created by majiancheng on 2017/12/11.
// Copyright (c) 2017 majiancheng. All rights reserved.
//

#import "NSURL+Extend.h"


@implementation NSURL (Extend)

+ (NSURL *)source4URI:(NSString *)uri {
    if (uri.length == 0) {
        return nil;
    }
    NSURL *URL = nil;
    if ([uri hasPrefix:@"http"] || [uri hasPrefix:@"https"]) {
        URL = [NSURL URLWithString:uri];
    } else if ([uri hasPrefix:@"/var/mobile/"]) {
        URL = [NSURL fileURLWithPath:uri];
    } else if ([uri hasPrefix:@"assets-library"]) {
        URL = [NSURL URLWithString:uri];
    } else {
        NSString *relativePath = [uri componentsSeparatedByString:@"file://"].lastObject;
        URL = [NSURL fileURLWithPath:relativePath];
    }
    return URL;
}

@end
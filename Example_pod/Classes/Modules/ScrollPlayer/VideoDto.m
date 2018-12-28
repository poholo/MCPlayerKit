//
// Created by majiancheng on 08/01/2018.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "VideoDto.h"


@implementation VideoDto

- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"video"]) {
        NSArray *array = value[@"url_list"];
        self.nomalUrl = array.firstObject;
        self.shd = array.lastObject;
        if (array.count > 0) {
            self.hd = array[1];
        }
        self.imageUrl = [value[@"cover_thumb"][@"url_list"] firstObject];
    } else if ([key isEqualToString:@"title"]) {
        self.name = value;
    }
}

@end
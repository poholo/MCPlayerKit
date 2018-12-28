//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "Dto.h"


@implementation Dto {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.entityId = [[NSUUID UUID] UUIDString];
    }
    return self;
}
@end
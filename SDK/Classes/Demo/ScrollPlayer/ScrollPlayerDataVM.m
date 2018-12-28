//
// Created by majiancheng on 08/01/2018.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "ScrollPlayerDataVM.h"
#import "Dto.h"
#import "VideoDto.h"


@implementation ScrollPlayerDataVM {

}

- (void)refresh {
    [super refresh];
    for (NSInteger idx = 0; idx < 5; idx++) {
        Dto *dto = [Dto new];
        [self.dataList addObject:dto];
    }
    {
        VideoDto *dto = [VideoDto new];
        [self.dataList addObject:dto];
    }
    for (NSInteger idx = 0; idx < 30; idx++) {
        Dto *dto = [Dto new];
        [self.dataList addObject:dto];
    }
}
@end
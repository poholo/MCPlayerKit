//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "PlayerNormalDataVM.h"
#import "PlayerNormalDto.h"


@implementation PlayerNormalDataVM {

}

- (void)refresh {
    [super refresh];
    {
        PlayerNormalDto *dto = [PlayerNormalDto new];
        dto.name = @"16:9";
        [self.dataList addObject:dto];
    }
}
@end
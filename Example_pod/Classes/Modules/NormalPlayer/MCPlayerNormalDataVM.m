//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "MCPlayerNormalDataVM.h"
#import "MCPlayerNormalDto.h"


@implementation MCPlayerNormalDataVM {

}

- (void)refresh {
    [super refresh];
    {
        MCPlayerNormalDto *dto = [MCPlayerNormalDto new];
        dto.name = @"16:9";
        [self.dataList addObject:dto];
    }
}
@end
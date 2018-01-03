//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "PlayerCategroiesDataVM.h"
#import "PlayerCategroryDto.h"
#import "PlayerNormalController.h"


@implementation PlayerCategroiesDataVM {

}

- (void)refresh {
    [super refresh];
    {
        PlayerCategroryDto *dto = [PlayerCategroryDto new];
        dto.name = @"16:9 固定模式";
        dto.actionClass = [PlayerNormalController class];
        [self.dataList addObject:dto];
    }
}
@end
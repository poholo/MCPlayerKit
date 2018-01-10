//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "PlayerCategroiesDataVM.h"

#import "PlayerCategroryDto.h"
#import "PlayerNormalController.h"
#import "ScrollPlayerController.h"
#import "ScrollPlayer2SmallPlayerController.h"


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

    {
        PlayerCategroryDto *dto = [PlayerCategroryDto new];
        dto.name = @"TableView 滚动";
        dto.actionClass = [ScrollPlayerController class];
        [self.dataList addObject:dto];
    }

    {
        PlayerCategroryDto *dto = [PlayerCategroryDto new];
        dto.name = @"CollectionView 滚动";
        dto.actionClass = [PlayerNormalController class];
        [self.dataList addObject:dto];
    }

    {
        PlayerCategroryDto *dto = [PlayerCategroryDto new];
        dto.name = @"ScrollView 滚动 + 小窗切换";
        dto.actionClass = [ScrollPlayer2SmallPlayerController class];
        [self.dataList addObject:dto];
    }

    {
        PlayerCategroryDto *dto = [PlayerCategroryDto new];
        dto.name = @"Music player";
        dto.actionClass = [PlayerNormalController class];
        [self.dataList addObject:dto];
    }

    {
        PlayerCategroryDto *dto = [PlayerCategroryDto new];
        dto.name = @"全局播放器";
        dto.actionClass = [PlayerNormalController class];
        [self.dataList addObject:dto];
    }

}
@end
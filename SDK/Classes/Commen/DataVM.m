//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "DataVM.h"
#import "Dto.h"


@implementation DataVM {

}

- (NSMutableArray<Dto *> *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray new];
    }
    return _dataList;
}

- (void)refresh {
    [self.dataList removeAllObjects];
}

@end
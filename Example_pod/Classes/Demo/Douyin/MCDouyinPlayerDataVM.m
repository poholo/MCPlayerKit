//
// Created by majiancheng on 2018/12/27.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "MCDouyinPlayerDataVM.h"
#import "VideoDto.h"


@implementation MCDouyinPlayerDataVM

- (void)refresh {
    [self.dataList removeAllObjects];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"VideoList" ofType:@"json"];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error:&error];
    for (NSDictionary *dict in dictionary[@"data"]) {
        VideoDto *dto = [VideoDto createDto:dict];
        [self.dataList addObject:dto];
    }
}


#pragma mark - getter

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray new];
    }
    return _dataList;
}

@end
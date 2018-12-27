//
// Created by majiancheng on 2018/12/27.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "MCDouyinPlayerListController.h"

#import "MCDouyinPlayerDataVM.h"
#import "MCDouyinPlayerCell.h"

@interface MCDouyinPlayerListController ()

@property(nonatomic, strong) MCDouyinPlayerDataVM *dataVM;

@end


@implementation MCDouyinPlayerListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTable];
    [self pullToRefresh];
}

- (void)pullToRefresh {
    [self.dataVM refresh];
    [self.tableView reloadData];
}

- (void)configTable {
    [self.tableView registerClass:[MCDouyinPlayerCell class] forCellReuseIdentifier:[MCDouyinPlayerCell identifier]];
}


#pragma mark - getter

- (MCDouyinPlayerDataVM *)dataVM {
    if (!_dataVM) {
        _dataVM = [MCDouyinPlayerDataVM new];
    }
    return _dataVM;
}
@end
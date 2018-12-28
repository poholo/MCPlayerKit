//
// Created by majiancheng on 2018/12/27.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "MCDouyinPlayerListController.h"

#import "MCDouyinPlayerDataVM.h"
#import "MCDouyinPlayerCell.h"
#import "MCDouyinPlayerView.h"
#import "MCPlayerKit.h"
#import "VideoDto.h"

@interface MCDouyinPlayerListController ()

@property(nonatomic, strong) MCPlayerKit *playerKit;
@property(nonatomic, strong) MCDouyinPlayerView *playerView;
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
    VideoDto *dto = self.dataVM.dataList[0];
    [self.playerKit playUrls:@[dto.hd]];
}

- (void)configTable {
    self.tableView.pagingEnabled = YES;
    [self.tableView registerClass:[MCDouyinPlayerCell class] forCellReuseIdentifier:[MCDouyinPlayerCell identifier]];
}

#pragma mark - table

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MCDouyinPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:[MCDouyinPlayerCell identifier] forIndexPath:indexPath];
    [cell updatePlayerView:self.playerView];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataVM.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MCDouyinPlayerCell height];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger idx = (NSInteger) (*targetContentOffset).y / (NSInteger) CGRectGetHeight([UIScreen mainScreen].bounds);
    VideoDto *dto = self.dataVM.dataList[idx];
    [self.playerKit playUrls:@[dto.hd]];
}

#pragma mark - getter

- (MCDouyinPlayerDataVM *)dataVM {
    if (!_dataVM) {
        _dataVM = [MCDouyinPlayerDataVM new];
    }
    return _dataVM;
}

- (MCPlayerKit *)playerKit {
    if (!_playerKit) {
        _playerKit = [[MCPlayerKit alloc] initWithPlayerView:self.playerView];
        _playerKit.playerCoreType = PlayerCoreIJKPlayer;
        _playerKit.actionAtItemEnd = PlayerActionAtItemEndCircle;
    }
    return _playerKit;
}

- (MCDouyinPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[MCDouyinPlayerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _playerView;
}

@end
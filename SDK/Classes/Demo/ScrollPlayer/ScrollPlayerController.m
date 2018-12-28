//
// Created by majiancheng on 08/01/2018.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "ScrollPlayerController.h"

#import "PlayerKit.h"
#import <Masonry.h>

#import "PlayerSimpleView.h"
#import "PlayerSimpleViewCell.h"
#import "TableViewPlaceHolderCell.h"
#import "DataVM.h"
#import "ScrollPlayerDataVM.h"
#import "VideoDto.h"

@interface ScrollPlayerController () <UITableViewDataSource, UITableViewDelegate, PlayerStatusDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) PlayerKit *playerKit;
@property(nonatomic, strong) PlayerSimpleView *playerView;

@end

@implementation ScrollPlayerController {

}

- (void)dealloc {
    [_playerKit destoryPlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];

    [self.dataVM refresh];
    [self.tableView reloadData];
    [self.playerKit playUrls:@[@"http://aliuwmp3.changba.com/userdata/video/45F6BD5E445E4C029C33DC5901307461.mp4"]];

}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataVM.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Dto *dto = self.dataVM.dataList[indexPath.row];
    if ([dto isKindOfClass:[VideoDto class]]) {
        PlayerSimpleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PlayerSimpleViewCell identifier] forIndexPath:indexPath];
        [cell updatePlayerView:self.playerView];
        return cell;
    } else {
        TableViewPlaceHolderCell *cell = [tableView dequeueReusableCellWithIdentifier:[TableViewPlaceHolderCell identifier] forIndexPath:indexPath];
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Dto *dto = self.dataVM.dataList[indexPath.row];
    if ([dto isKindOfClass:[VideoDto class]]) {
        return [PlayerSimpleViewCell height];
    } else {
        return [TableViewPlaceHolderCell height];
    }
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[PlayerSimpleViewCell class] forCellReuseIdentifier:[PlayerSimpleViewCell identifier]];
        [_tableView registerClass:[TableViewPlaceHolderCell class] forCellReuseIdentifier:[TableViewPlaceHolderCell identifier]];
    }
    return _tableView;
}

- (PlayerKit *)playerKit {
    if (!_playerKit) {
        _playerKit = [[PlayerKit alloc] initWithPlayerView:self.playerView];
        _playerKit.playerStatusDelegate = self;
        _playerKit.playerCoreType = PlayerCoreAVPlayer;
    }
    return _playerKit;
}

- (PlayerSimpleView *)playerView {
    if (!_playerView) {
        _playerView = [[PlayerSimpleView alloc] init];
    }
    return _playerView;
}

- (DataVM *)dataVM {
    if (!_dataVM) {
        _dataVM = [ScrollPlayerDataVM new];
    }
    return _dataVM;
}

@end
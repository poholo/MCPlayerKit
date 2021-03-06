//
// Created by majiancheng on 10/01/2018.
// Copyright (c) 2018 majiancheng. All rights reserved.
//


#import "ScrollPlayer2SmallPlayerController.h"

#import "MCPlayerKit.h"

#import "PlayerSimpleView.h"
#import "SmallPlayerView.h"
#import "TableViewPlaceHolderCell.h"
#import "PlayerSimpleViewCell.h"
#import "ScrollPlayerDataVM.h"
#import "VideoDto.h"

@interface ScrollPlayer2SmallPlayerController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) MCPlayerKit *playerKit;
@property(nonatomic, strong) PlayerSimpleView *playerView;
@property(nonatomic, strong) SmallPlayerView *smallPLayerView;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) PlayerSimpleViewCell *playerSimpleViewCell;
@property(nonatomic, strong) ScrollPlayerDataVM *dataVM;
@end


@implementation ScrollPlayer2SmallPlayerController {

}

#pragma mak -

- (void)dealloc {
    [_playerKit destory];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.smallPLayerView];
    self.smallPLayerView.hidden = YES;

    [self.dataVM refresh];
    [self.tableView reloadData];
    [self.playerKit playUrls:@[@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=bea0903abb954f58ac0e17c21226a3c3&line=1&app_id=1115&quality=720p"]];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataVM.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Dto *dto = self.dataVM.dataList[indexPath.row];
    if ([dto isKindOfClass:[VideoDto class]]) {
        self.playerSimpleViewCell = [tableView dequeueReusableCellWithIdentifier:[PlayerSimpleViewCell identifier] forIndexPath:indexPath];
        [self.playerSimpleViewCell updatePlayerView:self.playerView];
        return self.playerSimpleViewCell;
    } else {
        TableViewPlaceHolderCell *cell = [tableView dequeueReusableCellWithIdentifier:[TableViewPlaceHolderCell identifier] forIndexPath:indexPath];
        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([[self.tableView visibleCells] containsObject:self.playerSimpleViewCell]) {
        self.smallPLayerView.hidden = YES;
        [self.playerKit updatePlayerView:self.playerView];
    } else {
        [self.playerKit updatePlayerView:self.smallPLayerView];
        self.smallPLayerView.hidden = NO;
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

- (MCPlayerKit *)playerKit {
    if (!_playerKit) {
        _playerKit = [[MCPlayerKit alloc] initWithPlayerView:self.playerView];
        _playerKit.playerCoreType = MCPlayerCoreIJKPlayer;
        [_playerKit addDelegate:self];
    }
    return _playerKit;
}

- (PlayerSimpleView *)playerView {
    if (!_playerView) {
        _playerView = [[PlayerSimpleView alloc] init];
    }
    return _playerView;
}

- (SmallPlayerView *)smallPLayerView {
    if (!_smallPLayerView) {
        _smallPLayerView = [[SmallPlayerView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 300, CGRectGetHeight(self.view.frame) - 250 * 9 / 16.0f - 40, 250, 250 * 9 / 16.0f)];
    }
    return _smallPLayerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[TableViewPlaceHolderCell class] forCellReuseIdentifier:[TableViewPlaceHolderCell identifier]];
        [_tableView registerClass:[PlayerSimpleViewCell class] forCellReuseIdentifier:[PlayerSimpleViewCell identifier]];
    }
    return _tableView;
}

- (DataVM *)dataVM {
    if (!_dataVM) {
        _dataVM = [ScrollPlayerDataVM new];
    }
    return _dataVM;
}


@end

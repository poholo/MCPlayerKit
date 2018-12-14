//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "PlayerCategroiesTableController.h"

#import "PlayerCategroiesDataVM.h"
#import "PlayerCategroryCell.h"
#import "PlayerCategroryDto.h"

@interface PlayerCategroiesTableController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;

@end


@implementation PlayerCategroiesTableController {

}

- (instancetype)initWithParams:(NSDictionary *)params {
    self = [super initWithParams:params];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.dataVM refresh];

    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[PlayerCategroryCell class] forCellReuseIdentifier:[PlayerCategroryCell identifier]];
    [self.tableView reloadData];
}

#pragma mark - tableView data & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataVM.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayerCategroryCell *cell = [tableView dequeueReusableCellWithIdentifier:[PlayerCategroryCell identifier] forIndexPath:indexPath];
    [cell loadData:self.dataVM.dataList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PlayerCategroryCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayerCategroryDto *dto = (PlayerCategroryDto *) self.dataVM.dataList[indexPath.row];
    MCController *controller = [[dto.actionClass alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - getter

- (DataVM *)dataVM {
    if (!_dataVM) {
        _dataVM = [PlayerCategroiesDataVM new];
    }
    return _dataVM;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}


@end

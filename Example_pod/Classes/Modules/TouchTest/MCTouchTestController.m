//
// Created by majiancheng on 2019/1/3.
// Copyright (c) 2019 majiancheng. All rights reserved.
//

#import "MCTouchTestController.h"

#import "MCPlayerNormalTouchView.h"
#import "MCPlayerLoadingView.h"


@interface MCTouchTestController ()

@property(nonatomic, strong) MCPlayerNormalTouchView *touchView;

@property(nonatomic, strong) MCPlayerLoadingView *playerLoadingView;

@end

@implementation MCTouchTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.touchView];
    [self.view addSubview:self.playerLoadingView];
    self.touchView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 300);
    self.playerLoadingView.frame = CGRectMake(0, 300, CGRectGetWidth(self.view.frame), 300);

    [self.playerLoadingView startRotating];
}

#pragma mark - getter

- (MCPlayerNormalTouchView *)touchView {
    if (!_touchView) {
        _touchView = [MCPlayerNormalTouchView new];
        _touchView.backgroundColor = [UIColor redColor];
    }
    return _touchView;
}

- (MCPlayerLoadingView *)playerLoadingView {
    if (!_playerLoadingView) {
        _playerLoadingView = [MCPlayerLoadingView new];
    }
    return _playerLoadingView;
}
@end
//
// Created by majiancheng on 2019/1/3.
// Copyright (c) 2019 majiancheng. All rights reserved.
//

#import "MCTouchTestController.h"

#import "MCPlayerNormalTouchView.h"


@interface MCTouchTestController ()

@property (nonatomic, strong) MCPlayerNormalTouchView * touchView;
@end

@implementation MCTouchTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.touchView];
    self.touchView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 300);
}

#pragma mark - getter
- (MCPlayerNormalTouchView *)touchView {
    if(!_touchView) {
        _touchView = [MCPlayerNormalTouchView new];
        _touchView.backgroundColor = [UIColor redColor];
    }
    return _touchView;
}
@end
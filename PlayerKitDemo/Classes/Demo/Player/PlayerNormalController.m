//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//


#import "PlayerNormalController.h"

#import <MCPlayerKit/PlayerKit.h>

#import "PlayerNormalView.h"

@interface PlayerNormalController ()

@property(nonatomic, strong) PlayerKit *playerKit;
@property(nonatomic, strong) PlayerNormalView *playerView;

@end


@implementation PlayerNormalController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.playerView];
    [self.playerKit playUrls:@[@"http://aliuwmp3.changba.com/userdata/video/45F6BD5E445E4C029C33DC5901307461.mp4"]];
}

- (PlayerKit *)playerKit {
    if (!_playerKit) {
        _playerKit = [[PlayerKit alloc] initWithPlayerView:self.playerView];
        _playerKit.playerCoreType = PlayerCoreAVPlayer;
    }
    return _playerKit;
}

- (PlayerNormalView *)playerView {
    if (!_playerView) {
        CGFloat width = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        CGFloat height = width * 9 / 16.0f;
        _playerView = [[PlayerNormalView alloc] initWithFrame:CGRectMake(0, 64, width, height)];
    }
    return _playerView;
}

@end
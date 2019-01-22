//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "MCPlayerGeneralController.h"

#import <MCStyle/MCStyleDef.h>

#import "MCPlayerGeneralView.h"
#import "MCPlayerGeneralHeader.h"
#import "MCPlayerKit.h"
#import "MCDeviceUtils.h"
#import "MCPlayerCommonButton.h"
#import "MCTopRightView.h"


@interface MCPlayerGeneralController ()

@property(nonatomic, strong) MCPlayerKit *playerKit;
@property(nonatomic, strong) MCPlayerGeneralView *playerView;

@property(nonatomic, strong) MCPlayerCommonButton *btn;

@end


@implementation MCPlayerGeneralController {

}

- (void)dealloc {
    [_playerKit destory];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    [MCStyleManager share].colorStyleDataCallback = ^NSDictionary *(void) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CustomPlayerColor" ofType:@"json"];
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error:&error];
        NSAssert(!error, @"read json file error");
        return dictionary[@"data"];
    };

    [MCStyleManager share].fontStyleDataCallBack = ^NSDictionary *(void) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CustomPlayerFont" ofType:@"json"];
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error:&error];
        NSAssert(!error, @"read json file error");
        return dictionary[@"data"];
    };

    [MCStyleManager share].styleDataCallback = ^NSDictionary *(void) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CustomPlayerStyle" ofType:@"json"];
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error:&error];
        NSAssert(!error, @"read json file error");
        return dictionary[@"data"];
    };
    [[MCStyleManager share] loadData];

    [self.view addSubview:self.playerView];
    [self.playerView updatePlayerPicture:@"https://avatars0.githubusercontent.com/u/3861387?s=460&v=4"];
    [self.playerView updateTitle:@"Skipping code signing because the target does not have an Info.plist file. (in target 'App')"];
//    [self.playerKit playUrls:@[@"http://aliuwmp3.changba.com/userdata/video/45F6BD5E445E4C029C33DC5901307461.mp4"]];
    [self.playerKit playUrls:@[@"https://aaaapi.huoshan.com/hotsoon/item/video/_playback/?video_id=bea0903abb954f58ac0e17c21226a3c3&line=1&app_id=1115&quality=720p"]];
    [self.playerView updateAction:self.playerKit];
    self.playerView.retryPlayUrl = ^NSString *(void) {
        return @"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=bea0903abb954f58ac0e17c21226a3c3&line=1&app_id=1115&quality=720p";
    };

    [self.playerView.topView.rightView addCustom:self.btn];

    {
        MCPlayerCommonButton *btn = [MCPlayerCommonButton new];
        [btn setTitle:@"清晰度1" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor orangeColor]];
        btn.size = CGSizeMake(60, 30);
        btn.tag = 99;
        [self.playerView.topView.rightView addCustom:btn];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
    }

    {
        MCPlayerCommonButton *btn = [MCPlayerCommonButton new];
        [btn setTitle:@"清晰度2" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor orangeColor]];
        btn.size = CGSizeMake(60, 30);
        btn.tag = 0;
        [self.playerView.topView.rightView addCustom:btn];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self willEnterForground:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self didEnterBackground:nil];
}

- (void)didEnterBackground:(NSNotification *)notification {
    [_playerKit pause];
    _playerKit.playerEnvironment = PlayerEnvironmentOnResignActiveStatus;
}

- (void)willEnterForground:(NSNotification *)notification {
    _playerKit.playerEnvironment = PlayerEnvironmentOnBecomeActiveStatus;
    if (self.navigationController.topViewController == self) {
        [_playerKit play];
    } else {
        [_playerKit pause];
    }
}

#pragma mark - Rotate

- (BOOL)isSizeClassRegular {
    //如果是横屏全屏切换给切换机会
//    if (self.playerView.playerStyle == PlayerStyleSizeClassCompact) {
//        return NO;
//    }

    CGSize naturalSize = self.playerKit.naturalSize;
    if (naturalSize.width < naturalSize.height) {
        return YES;
    }
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL)shouldAutorotate {
    if ([self.playerView isLock]) {
        return NO;
    }
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {

    __weak typeof(self) weakSelf = self;
    [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
            [strongSelf.playerView rotate2Landscape];
        } else {
            [strongSelf.playerView rotate2Portrait];
        }

    }                            completion:nil];
}

#pragma mark - getter

- (MCPlayerKit *)playerKit {
    if (!_playerKit) {
        _playerKit = [[MCPlayerKit alloc] initWithPlayerView:self.playerView.playerView];
        _playerKit.playerCoreType = PlayerCoreAVPlayer;
    }
    return _playerKit;
}

- (MCPlayerGeneralView *)playerView {
    if (!_playerView) {
        CGFloat width = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        CGFloat height = width * 9 / 16.0f + [MCDeviceUtils xTop];
        _playerView = [[MCPlayerGeneralView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _playerView.canShowTerminalCallBack = ^BOOL(void) {
            return NO;
        };
    }
    return _playerView;
}

- (MCPlayerCommonButton *)btn {
    if (!_btn) {
        _btn = [MCPlayerCommonButton new];
        [_btn setTitle:@"清晰度" forState:UIControlStateNormal];
        [_btn setBackgroundColor:[UIColor orangeColor]];
        _btn.size = CGSizeMake(60, 30);
        _btn.showFullScreen = YES;
        _btn.showHalfScreen = NO;
    }
    return _btn;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end

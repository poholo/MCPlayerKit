//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//


#import "MCPlayerNormalController.h"

#import <Masonry.h>

#import "MCPlayerNormalView.h"
#import "MCPlayerNormalController+AutoRotate.h"
#import "MCPlayerKit.h"


@interface MCPlayerNormalController () <PlayerNormalViewDelegate, MCPlayerDelegate>

@property(nonatomic, strong) MCPlayerKit *playerKit;
@property(nonatomic, strong) MCPlayerNormalView *playerView;

@end


@implementation MCPlayerNormalController {

}

- (void)dealloc {
    [_playerKit destory];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        CGFloat width = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        CGFloat height = width * 9 / 16.0f;
        make.height.mas_equalTo(height);
    }];
    [self.playerKit playUrls:@[@"http://aliuwmp3.changba.com/userdata/video/45F6BD5E445E4C029C33DC5901307461.mp4"]];
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

#pragma mark - PlayerNormalViewDelegate

- (void)showShareView {

}

- (void)showAirplay {

}

- (void)playerPopViewController {
//    if (self.playerView.playerStyle != PlayerStyleSizeClassRegularHalf) {
//        [self updatePlayerRegularHalf];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)change2FullScreen {
    if ([self isSizeClassRegular]) {
        [self rotate2PortraitFullScreen];
    } else {
        [self updatePlayerRegular];
    }
}

- (void)change2Half {
    [self updatePlayerRegularHalf];
}

- (void)changeDefinitionRecordHistory {

}

- (void)changeDefinition:(DefinitionType)definitionType {

}

- (void)changeDefinitionSaveChange:(DefinitionType)definitionType {

}

- (void)actionDownload {

}

- (void)collectionBlock:(void (^)(BOOL success))complateBlock {

}

- (void)cancelCollectionBlock:(void (^)(BOOL success))complateBlock {

}

- (void)actionFeedBack {

}

- (void)playerStatusPause {

}

- (BOOL)beforeJumpShowAdInfo {
    return NO;
}

- (BOOL)isNotVideoPre {
    return NO;
}

- (void)showAdJumpInfo {

}

- (void)jumpPreAd:(BOOL)userJump duration:(NSInteger)currentTime {

}

- (void)jump2AdContent {

}

- (void)changeLoop:(BOOL)isLoop {

}

- (void)log2ShowHobble {

}

- (void)log2HobbleChange2Normal {

}

- (BOOL)isLocalVideo {
    return NO;
}

- (BOOL)canShowPlayPauseView {
    return NO;
}

- (void)feedBack {

}

- (void)playNextVideo {

}

#pragma mark log

- (void)logShowScreenAd {

}

- (void)logPause {

}

- (void)logPlay {

}

#pragma mark - PlayerStatusDelegate


- (void)playerStartplay {
}

- (void)playerStartError {
}

- (void)playerEndplay {
}

- (void)playEndPause {
}

- (void)playerEndAutoNext {
}

- (void)currentTime:(double)time {
}

- (BOOL)afterSeekNeed2Play {
    return YES;
}


#pragma mark - getter

- (MCPlayerKit *)playerKit {
    if (!_playerKit) {
        _playerKit = [[MCPlayerKit alloc] initWithPlayerView:self.playerView];
        _playerKit.playerCoreType = PlayerCoreAVPlayer;
        _playerKit.delegate = self;
    }
    return _playerKit;
}

- (MCPlayerNormalView *)playerView {
    if (!_playerView) {
        CGFloat width = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        CGFloat height = width * 9 / 16.0f;
        _playerView = [[MCPlayerNormalView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _playerView.playerNormalViewDelegate = self;

        [_playerView updateTitle:@"标题"];
        [_playerView updateSave:YES];
        [_playerView layoutIfNeeded];
        [_playerView updatePlayerPicture:nil];
        [_playerView showCanLoop:YES];
    }
    return _playerView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end

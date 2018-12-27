//
// Created by majiancheng on 2017/3/17.
// Copyright (c) 2017 mjc inc. All rights reserved.
//



#import "MCPlayerBaseView.h"

#import "PlayerViewConfig.h"

@class PlayerProgress;
@class PlayerTerminalView;
@class PlayerLoadingView;
@protocol PlayerTerminalDelegate;


@protocol PlayerNormalViewDelegate <NSObject>

@optional
- (void)showShareView;

- (void)showAirplay;

- (void)playerPopViewController;

- (void)change2FullScreen;

- (void)change2Half;

- (void)changeDefinitionRecordHistory;

- (void)changeDefinition:(DefinitionType)definitionType;

- (void)changeDefinitionSaveChange:(DefinitionType)definitionType;

- (void)actionDownload;

- (void)collectionBlock:(void (^)(BOOL success))complateBlock;

- (void)cancelCollectionBlock:(void (^)(BOOL success))complateBlock;

- (void)actionFeedBack;

- (void)playerStatusPause;

- (BOOL)beforeJumpShowAdInfo;

- (BOOL)isNotVideoPre;

- (void)showAdJumpInfo;

- (void)jumpPreAd:(BOOL)userJump duration:(NSInteger)currentTime;

- (void)jump2AdContent;

- (void)changeLoop:(BOOL)isLoop;

- (void)log2ShowHobble;

- (void)log2HobbleChange2Normal;

- (BOOL)isLocalVideo;

- (BOOL)canShowPlayPauseView;

- (void)feedBack;

- (void)playNextVideo;

//- (void)sliderPointClick:(SnapDto *)snapDto;

- (void)logShowScreenAd;

- (void)logPause;

- (void)logPlay;


@end


@interface PlayerNormalView : MCPlayerBaseView {
    UIView *_containerView;
    UIView *_touchView;
    UIButton *_backBtn;
    UILabel *_titleLabel;
    UIButton *_moreBtn;
    UIButton *_airplayBtn;

    UIButton *_shareBtn;
    UIButton *_downloadBtn;
    UIButton *_collectionBtn;
    UIButton *_loopBtn;

    UIButton *_playPauseBtn;
    UIButton *_portraitPlayPauseBtn;
    UIButton *_nextBtn;
    PlayerProgress *_playerProgress;
    PlayerProgress *_bottomPlayerProgress;
    UILabel *_leftLabel;
    UILabel *_rightLabel;
    UIButton *_fullScreenBtn;

    UIButton *_definitionBtn;
    UIButton *_lockBtn;

    CAGradientLayer *_topGradientLayer;
    CAGradientLayer *_bottomGradientLayer;

    UIView *_topControlView;
    UIView *_bottomControlView;
    PlayerTerminalView *_playerTerminalView;

    PlayerLoadingView *_loadingView;
    UIImageView *_waterImageView;

    UITapGestureRecognizer *_tapGesture;
    UIPanGestureRecognizer *_panGesture;


    CGPoint _panOrigin;
    double _timeSliding;
    BOOL _isChangeVolume;       ///< 是改变音量

    BOOL _ischangingVolume;        ///< 正在改变音量
    BOOL _isChangingBright;        ///< 正在调节亮度
    BOOL _isWillSeeking;           ///< 正在seek
    BOOL _isControlUIShow;
    BOOL _isWait2Seek;
    PlayerType _playerType;
}

@property(nonatomic, weak) id <PlayerNormalViewDelegate> playerNormalViewDelegate;
@property(nonatomic, weak) id <PlayerTerminalDelegate> playerTermailDelegate;

- (void)updatePlayStyle:(PlayerType)playerType;

- (void)updateTitle:(NSString *)title;

- (void)updateSave:(BOOL)state;

- (void)updatePlayerPicture:(NSString *)url;

- (void)controlWaterMark:(BOOL)animated;

- (void)updateFullScreenBtnStatus:(BOOL)fullScreen;

- (void)updateDefinitionNormal:(BOOL)hasNormal HD:(BOOL)hasHD UHD:(BOOL)hasUHD;

- (void)updateCurrentDefinition:(DefinitionType)definitionType;

- (void)updateHasQudan:(BOOL)hasQudan;

- (void)lockScreen:(BOOL)isLock;

- (BOOL)isLock;

- (void)showCanLoop:(BOOL)isLoop;

- (BOOL)isLoop;

- (void)resetLoop;

- (void)fadeShowAndThenHiddenAnimation;

@end

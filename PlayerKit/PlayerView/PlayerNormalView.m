//
// Created by majiancheng on 2017/3/17.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "PlayerNormalView.h"

#import <ReactiveCocoa.h>
#import <Masonry.h>
#import <MediaPlayer/MediaPlayer.h>
#import <WaQuBase/MMKeyChain.h>
#import <WaQuBase/ReachabilitySession.h>
#import <FXDanmaku/FXDanmaku.h>

#import "PlayerProgress.h"
#import "WQColorStyle.h"
#import "PlayerTerminalView.h"
#import "MCMediaNotify.h"
#import "PlayerLoadingView.h"
#import "PlayerRateBoard.h"
#import "UIScreen+Extend.h"
#import "UILabel+LabelSize.h"
#import "AirplayProtocol.h"
#import "PlayerViewControlDelegate.h"
#import "PlayerConfig.h"
#import "GCDQueue.h"
#import "UIColor+Extend.h"
#import "UIButton+BackgroundColor.h"
#import "ViewShapeMask.h"
#import "NSString+Size.h"
#import "UIColor+Hex.h"
#import "UALogger.h"
#import "WQUserSetting.h"
#import "MMTableView.h"
#import "MMDto.h"
#import "RefreshMoreTableTranslate.h"
#import "RACSignal.h"
#import "TableViewCell.h"
#import "PlayerQudanLineCell.h"
#import "MMVideoDto.h"
#import "Video.h"

#import "AppSetting.h"
#import "UserSession.h"
#import "LoginHelper.h"
#import "MMAdDto.h"
#import "PlayerPreAdView.h"
#import "PlayerFollowView.h"
#import "PlayerPauseView.h"
#import "MobileSSP.h"
#import "LogService.h"
#import "NSString+LogWord.h"
#import "LogParam.h"
#import "CBAutoScrollLabel.h"
#import "UtilsMacro.h"
#import "SnapDto.h"
#import "StringUtils.h"
#import "PlayerBulletView.h"
#import "BulletHelper.h"

@protocol _DefinitionViewDelegate <NSObject>

- (void)change2Normal;

- (void)change2Hight;

- (void)change2UHD;

@end

@interface _DefinitionView : UIView

@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *normalBtn;
@property(nonatomic, strong) UIButton *hightBtn;
@property(nonatomic, strong) UIButton *uhdBtn;

@property(nonatomic, assign) BOOL hasNormal;
@property(nonatomic, assign) BOOL hasHD;
@property(nonatomic, assign) BOOL hasUHD;

@property(nonatomic, weak) id <_DefinitionViewDelegate> delegate;

- (void)selectDefinitionType:(DefinitionType)type;

- (void)updateDefinitionNormal:(BOOL)hasNormal HD:(BOOL)hasHD UHD:(BOOL)hasUHD;

@end


@protocol _HobbleMentionViewDelelgate <NSObject>

- (void)change2Normal;

- (void)log2HobbleChange2Normal;

@end


typedef NS_ENUM(NSInteger, _HobbleMentionType) {
    HobbleMentionDefault,
    HobbleMentionQudianTitle
};

@interface _HobbleMentionView : UIView

@property(nonatomic, assign) CGFloat xRate;

@property(nonatomic, assign) _HobbleMentionType type;

@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UILabel *mentionLabel;

@property(nonatomic, weak) id <_HobbleMentionViewDelelgate> delegate;

- (void)updateBadNet;

- (void)updateMention:(NSString *)mention;

@end


//////////////////////////////////////


@protocol _QudanListViewDelegate <NSObject>

- (void)clickCell;

@end

@interface _QudanListViewTranslate : RefreshMoreTableTranslate

@property(nonatomic, weak) id <_QudanListViewTranslateDelegate> delegate;
@property(nonatomic, weak) id <_QudanListViewDelegate> qudanListViewDelegate;
@property(nonatomic, assign) BOOL isRefresh;
@property(nonatomic, strong) NSArray<MMDto *> *datas;
@property(nonatomic, assign) NSUInteger currentPlayIndex;

@property(nonatomic, strong) RACDisposable *dispose;

- (instancetype)initWithEmptyTableView:(UITableView *)tableView delegate:(id <_QudanListViewTranslateDelegate>)delegate;

- (void)disposeScroll;

@end


@interface _QudanListView : UIView <_QudanListViewDelegate>

@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) _QudanListViewTranslate *translate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id <_QudanListViewTranslateDelegate>)delegate;

@end

////////////////////////////////////
@interface PlayerNormalView () <PlayerRateBoardDelegate,
        _DefinitionViewDelegate,
        PlayerProgressDelegate,
        _HobbleMentionViewDelelgate,
        PlayerPreAdViewDelegate,
        PlayerPauseViewDelegate>

@property(nonatomic, strong) _DefinitionView *definitionView;
@property(nonatomic, assign) DefinitionType definitionType;

@property(nonatomic, strong) _HobbleMentionView *hobbleMentionView;
@property(nonatomic, strong) _HobbleMentionView *hobbleQudianMentionView;
@property(nonatomic, assign) NSTimeInterval hobbleStartTimeInterval;
@property(nonatomic, strong) RACDisposable *hobbleDispose;
@property(nonatomic, strong) RACDisposable *hobbleQudianDispose;

@property(nonatomic, strong) _QudanListView *qudanListView;

@property(nonatomic, strong) PlayerPreAdView *playerPreAdView;

@property(nonatomic, assign) BOOL hasNormal;
@property(nonatomic, assign) BOOL hasHD;
@property(nonatomic, assign) BOOL hasUHD;

@property(nonatomic, assign) PreVideoJumpType adJumpType;
@property(nonatomic, strong) NSArray<MMAdDto *> *baiduAds;

@property(nonatomic, strong) PlayerFollowView *playerFollowView;

@property(nonatomic, strong) PlayerPauseView *playerPauseView;

- (NSString *)decorateCountDownByJumpType;


@end


@implementation PlayerNormalView
- (void)dealloc {
    UALog(@"[%@]dealloc", NSStringFromClass([self class]));
    [self disposeQudianMentionView];
    [self disposeHobbleView];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeHiddenLockAnimation:) object:@(YES)];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeHiddenControlViewAnimation:) object:@(YES)];
}

- (void)disposeHobbleView {
    if (self.hobbleDispose) {
        [self.hobbleDispose dispose];
        self.hobbleDispose = nil;
    }
}

- (void)disposeQudianMentionView {
    if (self.hobbleQudianDispose) {
        [self.hobbleQudianDispose dispose];
        self.hobbleQudianDispose = nil;
    }
}

- (void)updatePlayerView:(UIView *)drawPlayerView {
    [super updatePlayerView:drawPlayerView];
    [self sendSubviewToBack:_drawView];
}

- (void)updatePlayerLayer:(CALayer *)layer {
    [super updatePlayerLayer:layer];
}

- (void)updatePlayStyle:(PlayerType)playerType {
    _playerType = playerType;
    if (_playerType != PlayerBaiduAd) {
        [_playerPreAdView removeFromSuperview];
        _playerPreAdView = nil;
    }
}

- (void)updateBaiduAd:(NSArray<MMAdDto *> *)baiduAds perDuration:(NSUInteger)perDuration sumOfDuration:(NSUInteger)sumOfDuration {
    self.baiduAds = baiduAds;
    [_playerPreAdView removeFromSuperview];
    _playerPreAdView = nil;
    [self.playerPreAdView updateBaiduAd:baiduAds perDuration:perDuration sumOfDuration:sumOfDuration];
    [self showLoading];

}

- (void)updateAdJumpType:(PreVideoJumpType)jumpType {
    _adJumpType = jumpType;
}

- (NSString *)decorateCountDownByJumpType {
    NSString *jumpStr;
    switch (_adJumpType) {
        case PreVideoNotJump: {
            jumpStr = @"";
        }
            break;
        case PreVideoAllCanJump: {
            jumpStr = @"跳过 | ";
        }
            break;
        case PreVideoLoginCanJump : {
            if ([[UserSession share] isLogin]) {
                jumpStr = @"跳过 | ";
            } else {
                jumpStr = @"登录跳过 | ";
            }
        }
            break;
        case PreVideoJumpOnlyDownload: {
            jumpStr = @"跳过 | ";
        }
    }
    return jumpStr;
}


- (void)updateTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)updateSave:(BOOL)state {
    _collectionBtn.selected = state;
}

- (void)updatePlayerPicture:(NSString *)url {
    [_loadingView updatePlayerPicture:url];
}

- (void)prepareUI {
    [super prepareUI];
    self.backgroundColor = [UIColor blackColor];
    _containerView = [[UIView alloc] init];
    [self addSubview:_containerView];

    _playerBulletView = [[PlayerBulletView alloc] init];
    [_containerView addSubview:_playerBulletView];

    _touchView = [[UIView alloc] init];
    [_containerView addSubview:_touchView];

    _topGradientLayer = ({
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.colors = @[(__bridge id) [UIColor rgba:0x00000099].CGColor, (__bridge id) [UIColor rgba:0x0000005].CGColor];
        layer.locations = @[@(.4)];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(0, 1.0);
        layer.frame = CGRectMake(0, 0, [UIScreen width], 50);

        _topControlView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen width], 50)];
            [_containerView addSubview:view];
            view.userInteractionEnabled = YES;
            view;
        });
        [_topControlView.layer addSublayer:layer];
        layer;
    });
    _bottomGradientLayer = ({
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.colors = @[(__bridge id) [UIColor rgba:0x00000005].CGColor, (__bridge id) [UIColor rgba:0x00000099].CGColor];
        layer.locations = @[@(.3)];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(0, 1.0);
        layer.frame = CGRectMake(0, 0, [UIScreen width], 50);
        _bottomControlView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen width], 50)];
            [_containerView addSubview:view];
            view.userInteractionEnabled = YES;
            view;
        });
        [_bottomControlView.layer addSublayer:layer];
        layer;
    });

    _backBtn = [[UIButton alloc] init];
    _titleLabel = ({
        CBAutoScrollLabel *autoLabel = [CBAutoScrollLabel new];
        autoLabel.textColor = [WQColorStyle whiteColor];
        autoLabel.font = [UIFont systemFontOfSize:15];

        [_containerView addSubview:autoLabel];

        autoLabel.textColor = [UIColor whiteColor];
        autoLabel.labelSpacing = 30; // distance between start and end labels
        autoLabel.pauseInterval = 1.7; // seconds of pause before scrolling starts again
        autoLabel.scrollSpeed = 30; // pixels per second
        autoLabel.textAlignment = NSTextAlignmentLeft; // centers text when no auto-scrolling is applied
        autoLabel.fadeLength = 0.f;
        autoLabel.scrollDirection = CBAutoScrollDirectionLeft;
        [autoLabel observeApplicationNotifications];
        autoLabel;
    });

    _moreBtn = [[UIButton alloc] init];
    _airplayBtn = [[UIButton alloc] init];

    _shareBtn = [[UIButton alloc] init];
    _downloadBtn = [[UIButton alloc] init];
    _collectionBtn = [[UIButton alloc] init];
    _loopBtn = [[UIButton alloc] init];

    _playPauseBtn = [[UIButton alloc] init];
    _portraitPlayPauseBtn = [[UIButton alloc] init];
    _nextBtn = [[UIButton alloc] init];
    _playerProgress = [[PlayerProgress alloc] init];
    _bottomPlayerProgress = [[PlayerProgress alloc] init];
    [_bottomPlayerProgress changeSliderStyle:SliderShowProgress];
    _leftLabel = [[UILabel alloc] init];
    _rightLabel = [[UILabel alloc] init];
    _fullScreenBtn = [[UIButton alloc] init];

    _definitionBtn = [[UIButton alloc] init];
    _qudanBtn = [[UIButton alloc] init];
    _jumpBtn = [[UIButton alloc] init];
    _lockBtn = [[UIButton alloc] init];

    [_containerView addSubview:_backBtn];

    [_containerView addSubview:_moreBtn];
    [_containerView addSubview:_airplayBtn];
    [_containerView addSubview:_shareBtn];
    [_containerView addSubview:_downloadBtn];
    [_containerView addSubview:_collectionBtn];
    [_containerView addSubview:_loopBtn];

    [_containerView addSubview:_playPauseBtn];
    [_containerView addSubview:_portraitPlayPauseBtn];
    [_containerView addSubview:_nextBtn];
    [_containerView addSubview:_playerProgress];
    [_containerView addSubview:_bottomPlayerProgress];
    [_containerView addSubview:_leftLabel];
    [_containerView addSubview:_rightLabel];
    [_containerView addSubview:_fullScreenBtn];
    [_containerView addSubview:_definitionBtn];
    [_containerView addSubview:_qudanBtn];
    [_containerView addSubview:_jumpBtn];
    [_containerView addSubview:_lockBtn];

    {
        UIEdgeInsets inset = UIEdgeInsetsZero;
        _playPauseBtn.imageEdgeInsets = inset;
        _nextBtn.imageEdgeInsets = inset;
        _fullScreenBtn.imageEdgeInsets = inset;;

    }

    [_backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];

    [_moreBtn setImage:[UIImage imageNamed:@"more_whte"] forState:UIControlStateNormal];
    [_airplayBtn setImage:[UIImage imageNamed:@"player_tv"] forState:UIControlStateNormal];

    [_shareBtn setImage:[UIImage imageNamed:@"share_white"] forState:UIControlStateNormal];
    [_downloadBtn setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];

    [_collectionBtn setImage:[UIImage imageNamed:@"favorites_white"] forState:UIControlStateNormal];
    [_collectionBtn setImage:[UIImage imageNamed:@"collect_red"] forState:UIControlStateSelected];

    [_playPauseBtn setImage:[UIImage imageNamed:@"pause-full"] forState:UIControlStateNormal];
    [_playPauseBtn setImage:[UIImage imageNamed:@"play-full"] forState:UIControlStateSelected];

    [_portraitPlayPauseBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [_portraitPlayPauseBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];

    [_nextBtn setImage:[UIImage imageNamed:@"next-full"] forState:UIControlStateNormal];

    [_lockBtn setImage:[UIImage imageNamed:@"ic_unlocking"] forState:UIControlStateNormal];
    [_lockBtn setImage:[UIImage imageNamed:@"ic_lock"] forState:UIControlStateSelected];

    [_loopBtn setImage:[UIImage imageNamed:@"ic_order"] forState:UIControlStateNormal];
    [_loopBtn setImage:[UIImage imageNamed:@"ic_order_one"] forState:UIControlStateSelected];

    [_definitionBtn setTitle:({
        NSString *name = @"标清";

        DefinitionType definitionType = [[WQUserSetting sharedInstance] getUserSettingwithUserID:[MMKeyChain openUDID]].definitionType;
        switch (definitionType) {
            case DTNormal: {
                name = @"标清";
            }
                break;
            case DTHight : {
                name = @"高清";
            }
                break;
            case DTUHight: {
                name = @"超清";
            }
                break;
        }
        name;
    })              forState:UIControlStateNormal];
    _definitionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_definitionBtn setTitleColor:[WQColorStyle whiteColor] forState:UIControlStateNormal];
    [_definitionBtn setTitleColor:[WQColorStyle shallowBlueColor] forState:UIControlStateHighlighted];

    [_qudanBtn setTitle:@"趣单" forState:UIControlStateNormal];
    _qudanBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_qudanBtn setTitleColor:[WQColorStyle whiteColor] forState:UIControlStateNormal];
    [_qudanBtn setTitleColor:[WQColorStyle shallowBlueColor] forState:UIControlStateHighlighted];

    [_jumpBtn setBackgroundColor:[UIColor rgba:0x00000099] forState:UIControlStateNormal];
    [ViewShapeMask cornerView:_jumpBtn radius:10 border:0 color:nil];
    _jumpBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_jumpBtn setTitleColor:[WQColorStyle whiteColor] forState:UIControlStateNormal];

    _leftLabel.font = [UIFont systemFontOfSize:10];
    _leftLabel.textColor = [WQColorStyle whiteColor];
    _rightLabel.font = [UIFont systemFontOfSize:10];
    _rightLabel.textColor = [WQColorStyle whiteColor];
    _leftLabel.text = @"00:00";
    _rightLabel.text = @"00:00";

    [_fullScreenBtn setImage:[UIImage imageNamed:@"zuidahua-full"] forState:UIControlStateNormal];
    [_fullScreenBtn setImage:[UIImage imageNamed:@"zuixiaohua-full"] forState:UIControlStateSelected];

    [_backBtn addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];

    [_moreBtn addTarget:self action:@selector(btnMoreClick) forControlEvents:UIControlEventTouchUpInside];
    [_airplayBtn addTarget:self action:@selector(btnAirPlayClick) forControlEvents:UIControlEventTouchUpInside];

    [_shareBtn addTarget:self action:@selector(btnShareClick) forControlEvents:UIControlEventTouchUpInside];
    [_downloadBtn addTarget:self action:@selector(btnDownloadClick) forControlEvents:UIControlEventTouchUpInside];
    [_collectionBtn addTarget:self action:@selector(btnCollectionClick) forControlEvents:UIControlEventTouchUpInside];
    [_loopBtn addTarget:self action:@selector(btnLoopClick) forControlEvents:UIControlEventTouchUpInside];

    [_playPauseBtn addTarget:self action:@selector(btnPlayPauseClick) forControlEvents:UIControlEventTouchUpInside];
    [_portraitPlayPauseBtn addTarget:self action:@selector(btnPlayPauseClick) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_fullScreenBtn addTarget:self action:@selector(btnFullClick) forControlEvents:UIControlEventTouchUpInside];
    [_definitionBtn addTarget:self action:@selector(btnDefinitionClick) forControlEvents:UIControlEventTouchUpInside];
    [_qudanBtn addTarget:self action:@selector(btnQudanClick) forControlEvents:UIControlEventTouchUpInside];
    [_jumpBtn addTarget:self action:@selector(btnJumpAdClick) forControlEvents:UIControlEventTouchUpInside];
    [_lockBtn addTarget:self action:@selector(btnLockClick) forControlEvents:UIControlEventTouchUpInside];

    _playerProgress.delegate = self;

    _definitionBtn.alpha = 0.0;
    _shareBtn.alpha = 0.0;
    _titleLabel.alpha = 0.0;
    _qudanBtn.alpha = 0.0;
    _playPauseBtn.alpha = 0.0;

    _loadingView = [[PlayerLoadingView alloc] init];
    [self insertSubview:_loadingView atIndex:PlayerLayerLevelLoadingView];

    _waterImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_k_AV_water_image]];
    _waterImageView.alpha = .6f;
    [self insertSubview:_waterImageView atIndex:PlayerLayerLevelWater];

    [self playerTerminalView];

    _playerRateBoard = ({
        PlayerRateBoard *playerRateBoard = [[PlayerRateBoard alloc] init];
        playerRateBoard.delegate = self;
        [self addSubview:playerRateBoard];
        playerRateBoard.hidden = YES;
        playerRateBoard;
    });

    [self updateLayerIndex];

    if ([AppSetting isDownloadable]) {
        _airplayBtn.hidden = NO;
        _downloadBtn.hidden = NO;
    } else {
        _airplayBtn.hidden = YES;
        _downloadBtn.hidden = YES;
    }

}

- (void)setPlayerTermailDelegate:(id <PlayerTerminalDelegate>)playerTermailDelegate {
    _playerTermailDelegate = playerTermailDelegate;
    self.playerTerminalView.delegate = playerTermailDelegate;
}

- (_DefinitionView *)definitionView {
    [self removeDefinitionView];
    if (_definitionView == nil) {
        _definitionView = [[_DefinitionView alloc] initWithFrame:_containerView.bounds];
        [_definitionView updateDefinitionNormal:self.hasNormal HD:self.hasHD UHD:self.hasUHD];
        [_definitionView selectDefinitionType:self.definitionType];
        _definitionView.delegate = self;
        [_containerView addSubview:_definitionView];
        [_containerView bringSubviewToFront:_definitionView];
    }
    return _definitionView;
}

- (_HobbleMentionView *)hobbleMentionView {
    [self removeHobbleMentionView];
    if (_hobbleMentionView == nil) {
        _hobbleMentionView = [[_HobbleMentionView alloc] initWithFrame:CGRectMake(15, self.frame.size.height - 60, 230, 30)];
        _hobbleMentionView.delegate = self;
        [_hobbleMentionView updateBadNet];
        [self addSubview:_hobbleMentionView];
        [self bringSubviewToFront:_hobbleMentionView];
        [self insertSubview:_hobbleMentionView atIndex:PlayerLayerLevelBackView];
        if ([self.playerNormalViewDelegate respondsToSelector:@selector(log2ShowHobble)]) {
            [self.playerNormalViewDelegate log2ShowHobble];
        }
    }
    return _hobbleMentionView;
}

- (_HobbleMentionView *)hobbleQudianMentionView {
    if (_hobbleQudianMentionView == nil) {
        _hobbleQudianMentionView = [[_HobbleMentionView alloc] initWithFrame:CGRectMake(15, self.frame.size.height - 60, 230, 30)];
        [self addSubview:_hobbleQudianMentionView];
        [self bringSubviewToFront:_hobbleQudianMentionView];
        [self insertSubview:_hobbleQudianMentionView atIndex:PlayerLayerLevelBackView];
        [self disposeQudianMentionView];
        @weakify(self);
        self.hobbleQudianDispose = [[RACScheduler mainThreadScheduler] afterDelay:30 schedule:^{
            @strongify(self);
            [self removeHobbleQudianMentionView];
        }];
    }
    return _hobbleQudianMentionView;
}

- (_QudanListView *)qudanListView {
    [self removeQudanListView];
    if (_qudanListView == nil) {
        _qudanListView = [[_QudanListView alloc] initWithFrame:_containerView.bounds delegate:self.qudanListViewTranslateDelegate];

        [self addSubview:_qudanListView];
        [self bringSubviewToFront:_qudanListView];
        [self insertSubview:_qudanListView atIndex:PlayerLayerLevelBackView];
    }
    return _qudanListView;
}

- (PlayerPreAdView *)playerPreAdView {
    if (_playerPreAdView == nil) {
        _playerPreAdView = [[PlayerPreAdView alloc] initWithFrame:_containerView.bounds];
        [_playerPreAdView setAdRefer:self.logParam.refer];
        _playerPreAdView.delegate = self;
        [_containerView addSubview:_playerPreAdView];
        [_containerView bringSubviewToFront:_playerPreAdView];
        [_containerView bringSubviewToFront:_jumpBtn];
    }
    return _playerPreAdView;
}

- (PlayerFollowView *)playerFollowView {
    return nil;
    if (_playerFollowView == nil) {
        _playerFollowView = [[PlayerFollowView alloc] init];
        _playerFollowView.delegate = self.playerFollowViewDelegate;
        [self addSubview:_playerFollowView];
        [self bringSubviewToFront:_playerFollowView];
        @weakify(self);
        [_playerFollowView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.mas_equalTo(self.mas_right).offset(200);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-60);
        }];
        [_playerFollowView layoutIfNeeded];
    }
    return _playerFollowView;
}

- (void)setPlayerStyle:(PlayerStyle)playerStyle {
    if (_playerPauseView) {
        [_playerPauseView removeFromSuperview];
        _playerPauseView = nil;
        [self addPanGesture];
    }
    _playerStyle = playerStyle;
    [_playerRateBoard setPlayerStyle:playerStyle];
    switch (_playerStyle) {
        case PlayerStyleSizeClassCompact: {
            _airplayBtn.alpha = 0.0;
            _qudanBtn.alpha = _moreBtn.alpha;
            _definitionBtn.alpha = _moreBtn.alpha;
            _shareBtn.alpha = _moreBtn.alpha;
            _downloadBtn.alpha = _moreBtn.alpha;
            _collectionBtn.alpha = _moreBtn.alpha;
            _titleLabel.alpha = _moreBtn.alpha;
            _lockBtn.alpha = _moreBtn.alpha;
            _loopBtn.alpha = 0.0;
            _playPauseBtn.alpha = _moreBtn.alpha;
            _portraitPlayPauseBtn.alpha = 0.0;
            _nextBtn.alpha = _moreBtn.alpha;
        }
            break;
        case PlayerStyleSizeClassRegular: {
            _airplayBtn.alpha = 0.0;
            _qudanBtn.alpha = _moreBtn.alpha;
            _definitionBtn.alpha = _moreBtn.alpha;
            _shareBtn.alpha = _moreBtn.alpha;
            _downloadBtn.alpha = _moreBtn.alpha;
            _collectionBtn.alpha = _moreBtn.alpha;
            _titleLabel.alpha = _moreBtn.alpha;
            _lockBtn.alpha = _moreBtn.alpha;
            _loopBtn.alpha = _moreBtn.alpha;
            _playPauseBtn.alpha = 0.0;
            _portraitPlayPauseBtn.alpha = _moreBtn.alpha;
            _nextBtn.alpha = 0.0f;

        }
            break;
        case PlayerStyleSizeClassRegularHalf: {
            _definitionBtn.alpha = 0.0;
            _qudanBtn.alpha = 0.0;
            _airplayBtn.alpha = _moreBtn.alpha;
            _shareBtn.alpha = 0.0;
            _downloadBtn.alpha = 0.0;
            _collectionBtn.alpha = 0.0;
            _titleLabel.alpha = 0.0;
            _lockBtn.alpha = 0.0;
            _loopBtn.alpha = _moreBtn.alpha;
            _playPauseBtn.alpha = 0.0;
            _portraitPlayPauseBtn.alpha = _moreBtn.alpha;
            _nextBtn.alpha = 0.0;
            [self removeQudanListView];
        }
            break;
    }

    [self updateQudianMentionFrame];

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];

    [self removeDefinitionView];
}

- (void)updateLayerIndex {
    [self insertSubview:_waterImageView atIndex:PlayerLayerLevelWater];
    [self insertSubview:_containerView atIndex:PlayerLayerLevelNormalControlBar];
    [self insertSubview:_playerRateBoard atIndex:PlayerLayerLevelPlayerRate];
    [self insertSubview:_loadingView atIndex:PlayerLayerLevelLoadingView];
    [self insertSubview:_playerTerminalView atIndex:PlayerLayerLevelTerminal];
    [self insertSubview:_backBtn atIndex:PlayerLayerLevelBackView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _topControlView.frame = CGRectMake(0, 0, self.frame.size.width, 50);
    _bottomControlView.frame = CGRectMake(0, self.frame.size.height - 55, self.frame.size.width, 55);
    _topGradientLayer.frame = _topControlView.bounds;
    _bottomGradientLayer.frame = _bottomControlView.bounds;
    _playerPreAdView.frame = self.bounds;
    [_playerPreAdView setNeedsLayout];
    [_playerPreAdView setNeedsUpdateConstraints];
    [_playerPreAdView layoutIfNeeded];
    _playerBulletView.frame = self.bounds;

    [self updateQudianMentionFrame];
}

- (void)updateConstraints {
    @weakify(self);
    [_containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.bottom.equalTo(self);
    }];

    [_touchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.bottom.equalTo(self->_containerView);
    }];

    CGFloat top = 0;
    if (self.playerStyle == PlayerStyleSizeClassRegularHalf || self.playerStyle == PlayerStyleSizeClassRegular) {
        top = 15;
    }
    [_backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self).offset(top);
        make.left.equalTo(self).offset(0);
        make.width.height.mas_equalTo(35);
    }];

    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self->_backBtn);
        make.left.equalTo(self->_backBtn.mas_right).offset(10);
        make.right.equalTo(self->_collectionBtn.mas_left).offset(-10);
        make.height.mas_equalTo(16);
    }];

    CGFloat btnWidth = 40;
    [_moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(top);
        make.width.height.mas_equalTo(btnWidth);
    }];

    [_airplayBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        if (self.playerStyle == PlayerStyleSizeClassRegularHalf) {
            make.right.equalTo(self->_moreBtn.mas_left).offset(-10);
        } else {
            make.right.equalTo(self->_shareBtn.mas_left).offset(-10);
        }
        make.top.equalTo(self->_backBtn);
        make.width.height.mas_equalTo(btnWidth);
    }];

    [_shareBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self->_moreBtn.mas_left).offset(-10);
        make.top.equalTo(self->_backBtn);
        make.width.height.mas_equalTo(btnWidth);
    }];


    [_downloadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self->_shareBtn.mas_left).offset(-10);
        make.top.equalTo(self->_backBtn);
        make.width.height.mas_equalTo(btnWidth);
    }];

    [_collectionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        if ([AppSetting isDownloadable]) {
            make.right.equalTo(self->_downloadBtn.mas_left).offset(-10);
        } else {
            make.right.equalTo(self->_shareBtn.mas_left).offset(-10);
        }
        make.top.equalTo(self->_backBtn);
        make.width.height.mas_equalTo(btnWidth);
    }];

    [_loopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self->_backBtn);
        make.width.height.mas_equalTo(btnWidth);
        make.right.equalTo(self->_airplayBtn.mas_left).offset(-10);
    }];

    CGFloat bottomHeight = ({
        CGFloat w = 25;
        switch (self.playerStyle) {
            case PlayerStyleSizeClassRegularHalf : {
                w = 25;
            }
                break;
            case PlayerStyleSizeClassRegular: {
                w = 35;
            }
                break;
            case PlayerStyleSizeClassCompact: {
                w = 40;
            }
                break;
        }
        w;
    });
    [_playPauseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.width.height.mas_equalTo(bottomHeight);
    }];

    [_portraitPlayPauseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(60);
    }];

    [_nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(_playPauseBtn.mas_right).offset(10);
        make.centerY.equalTo(_playPauseBtn);
        make.width.height.equalTo(_playPauseBtn);
    }];

    [_leftLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        if (_playerStyle != PlayerStyleSizeClassCompact) {
            make.left.equalTo(self->_containerView.mas_left).offset(5);
        } else {
            make.left.equalTo(self->_nextBtn.mas_right).offset(5);
        }
        make.centerY.equalTo(self->_playPauseBtn);
    }];


    [_fullScreenBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self->_containerView.mas_right).offset(-10);
        make.centerY.equalTo(self->_playPauseBtn);
        make.width.height.mas_equalTo(bottomHeight);
    }];

    [_qudanBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self->_fullScreenBtn.mas_left).offset(-5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(bottomHeight);
        make.centerY.equalTo(self->_playPauseBtn);
    }];

    [_definitionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        if (_qudanBtn.hidden) {
            make.right.equalTo(self->_fullScreenBtn.mas_left).offset(-5);
        } else {
            make.right.equalTo(self->_qudanBtn.mas_left).offset(-5);
        }
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(bottomHeight);
        make.centerY.equalTo(self->_playPauseBtn);
    }];

    [_rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        if (self.playerStyle == PlayerStyleSizeClassRegularHalf) {
            make.right.equalTo(self->_fullScreenBtn.mas_left).offset(-5);
        } else {
            make.right.equalTo(self->_definitionBtn.mas_left).offset(-5);
        }
        make.centerY.equalTo(self->_playPauseBtn);
    }];

    [_playerProgress mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self->_leftLabel.mas_right).offset(5);
        make.bottom.equalTo(self->_containerView.mas_bottom);
        make.top.equalTo(self->_playPauseBtn.mas_top).offset(-10);
        make.right.equalTo(self->_rightLabel.mas_left).offset(-5);
    }];

    [_playerProgress layoutIfNeeded];

    [_bottomPlayerProgress mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self->_containerView.mas_left);
        make.bottom.equalTo(self->_containerView.mas_bottom);
        make.height.mas_equalTo(2);
        make.right.equalTo(self->_containerView.mas_right);
    }];

    [_bottomPlayerProgress layoutIfNeeded];

    [_loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self);
    }];

    [_waterImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        CGFloat top = 15;
        make.right.equalTo(self).offset(-10);
        if (self.playerStyle == PlayerStyleSizeClassCompact) {
            top = 20;
            _waterImageView.image = [UIImage imageNamed:_k_AV_water_land_image];
        } else {
            _waterImageView.image = [UIImage imageNamed:_k_AV_water_image];
        }

        make.top.equalTo(self).offset(top);
        make.size.mas_equalTo(_waterImageView.image.size);
    }];

    [_playerRateBoard mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.right.bottom.equalTo(self);
    }];
    [_playerRateBoard layoutIfNeeded];


    [_playerTerminalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.right.bottom.equalTo(self);
    }];

    [_playerBulletView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.right.bottom.equalTo(self);
    }];

    [_jumpBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self->_containerView).offset(20);
        make.right.equalTo(self->_containerView.mas_right).offset(-20);
        make.width.mas_equalTo([_jumpBtn.titleLabel.text size4size:CGSizeMake(CGFLOAT_MAX, 25) font:[UIFont systemFontOfSize:12]].width + 20);
        make.height.mas_equalTo(25);
    }];

    [_lockBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.height.mas_equalTo(50);
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(15);
    }];

    [super updateConstraints];
}

- (PlayerTerminalView *)playerTerminalView {
    if (_playerTerminalView == nil) {
        _playerTerminalView = [[PlayerTerminalView alloc] initWithFrame:CGRectZero];
        [_containerView addSubview:_playerTerminalView];
        [_containerView insertSubview:_playerTerminalView atIndex:PlayerLayerLevelTerminal];
    }
    return _playerTerminalView;

}

#pragma mark -
#pragma mark

- (void)showPlayBtnPlay:(BOOL)isPlay {
    _playPauseBtn.selected = !isPlay;
    _portraitPlayPauseBtn.selected = _playPauseBtn.selected;
    [_playerPreAdView enable:isPlay];
    if (_playerType != PlayerNormal || isPlay) {
        [_playerPauseView removeFromSuperview];
        [self addPanGesture];
        _playerPauseView = nil;
    }
    if (_playerType != PlayerNormal) {
        [_playerPauseView removeFromSuperview];
        _playerPauseView = nil;
        return;
    }
    if (!isPlay) {
        switch (self.playerStyle) {
            case PlayerStyleSizeClassRegularHalf: {
                [_playerPauseView removeFromSuperview];
                _playerPauseView = nil;
            }
                break;  ///<  16:9 半屏幕
            case PlayerStyleSizeClassRegular: {
                [self showPlayPauseAdView];
            }
                break;      ///<  竖屏全屏
            case PlayerStyleSizeClassCompact: {
                [self showPlayPauseAdView];
            }

                break;
            default: {
            }
                break;
        }
    }
}

- (void)showPlayPauseAdView {
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(canShowPlayPauseView)]) {
        BOOL canShow = [self.playerNormalViewDelegate canShowPlayPauseView];
        if (canShow) {
            [_playerPauseView removeFromSuperview];
            _playerPauseView = nil;

            CGRect frame = CGRectMake(({
                        CGFloat x = MAX([UIScreen width], [UIScreen height]) / 2.0 - 275 / 2.0;
                        if (self.playerStyle == PlayerStyleSizeClassRegular) {
                            x = MIN([UIScreen width], [UIScreen height]) / 2.0 - 275 / 2.0;
                        }
                        x;
                    }),
                    MIN([UIScreen width], [UIScreen height]) / 2.0 - 190 / 2.0,
                    275,
                    190);
            _playerPauseView = [[PlayerPauseView alloc] initWithFrame:frame];
            _playerPreAdView.logParam = self.logParam;
            _playerPauseView.delegate = self;
            [self addSubview:_playerPauseView];

            if ([self.playerNormalViewDelegate respondsToSelector:@selector(logShowScreenAd)]) {
                [self.playerNormalViewDelegate logShowScreenAd];
            }
            [self removePanGesture];

        } else {
            [_playerPauseView removeFromSuperview];
            _playerPauseView = nil;
        }
    }
}

- (void)showLoading {
    if (_playerType == PlayerBaiduAd) {
        _playerTerminalView.hidden = YES;
        [self fadeHiddenControlViewAnimation:@(YES)];
        [_loadingView endRotating];
    } else {
        _playerTerminalView.hidden = YES;
        [self fadeHiddenControlViewAnimation:@(YES)];
        [_loadingView startRotatingAndDefaultBg];
    }
    [self removePanGesture];
    [self removeTapGesture];
    self.hobbleStartTimeInterval = 0;
}

- (void)showLoadingNoDefaultBg {
    if (self.definitionType != DTNormal
            && [self.playerNormalViewDelegate respondsToSelector:@selector(isLocalVideo)]
            && ![self.playerNormalViewDelegate isLocalVideo]
            && ![_definitionBtn.titleLabel.text isEqualToString:@"标清"]) {
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
        if (timeInterval - self.hobbleStartTimeInterval > 30) {
            self.hobbleStartTimeInterval = timeInterval;
        }
        if (timeInterval - self.hobbleStartTimeInterval > 5.0) {
            [self hobbleMentionView];
            RACScheduler *scheduler = [RACScheduler mainThreadScheduler];
            @weakify(self);
            self.hobbleDispose = [scheduler afterDelay:10 schedule:^{
                @strongify(self);
                self.hobbleStartTimeInterval = 0;
                [self removeHobbleMentionView];
            }];
        }
    }
    [self fadeHiddenControlViewAnimation:@(YES)];
    _playerTerminalView.hidden = YES;
    [_loadingView startRotatingNoDefaultBg];
}

/** WQPlayerStateBuffering,  ///< 缓冲中   */
- (void)showBuffering {
    self.playerTerminalView.hidden = YES;
}

/** WQPlayerStateStarting,   ///< 开始播放  */
- (void)showStateStarting {
    //    [self fadeShowControlViewAnimation:@(YES)];
    [self fadeShowAndThenHiddenAnimation];
    self.playerTerminalView.hidden = YES;
    [self addPanGesture];
    [self addTapGesture];
    [_loadingView endRotating];
}

/** WQPlayerStatePlaying,    ///< 播放中   */
- (void)showPlaying {
    self.playerTerminalView.hidden = YES;
    [self addPanGesture];
    [self addTapGesture];
    [_loadingView endRotating];
}

/** WQPlayerStatePlayEnd,    ///< 播放结束  */
- (void)showPlayEnd {
    self.hobbleStartTimeInterval = 0;
    [_loadingView startShowBg];
}

/** WQPlayerStatePausing,    ///< 暂停    */
- (void)showPausing {
    _playerTerminalView.hidden = YES;
}

/** WQPlayerStateStopped,    ///< 停止播放  */
- (void)showStopped {
    _playerTerminalView.hidden = YES;

}


/** WQPlyaerState3GUnenable */
- (void)show3GUnenable {
    _playerTerminalView.hidden = NO;

    [self removeTapGesture];
    [self removePanGesture];

    [self.playerTerminalView updatePlayerTerminal:PlayerState3GUnenable title:_titleLabel.text];
    [self fadeHiddenControlViewAnimation:@(NO)];

}

/** WQPlayerStateNetError,  ///< 播放错误[网络]  */
- (void)showNetError {
    self.playerTerminalView.hidden = NO;
    [_loadingView endRotating];

    [self removeTapGesture];
    [self removePanGesture];

    [self.playerTerminalView updatePlayerTerminal:PlayerStateNetError title:_titleLabel.text];
    [self fadeHiddenControlViewAnimation:@(NO)];
}

/** WQPlayerStateUrlError,  ///< 播放路径错误    */
- (void)showUrlError {
    self.playerTerminalView.hidden = NO;
    [_loadingView endRotating];
    [self.playerTerminalView updatePlayerTerminal:PlayerStateUrlError title:_titleLabel.text];
    [self fadeHiddenControlViewAnimation:@(NO)];
}

/** WQPlayerStateError,     ///< 播放路径错误    */
- (void)showError {
    self.playerTerminalView.hidden = NO;
    [_loadingView endRotating];
    [self removeTapGesture];
    [self removePanGesture];

    [self.playerTerminalView updatePlayerTerminal:PlayerStateError title:_titleLabel.text];
    [self fadeHiddenControlViewAnimation:@(NO)];
}

- (void)controlWaterMark:(BOOL)animated {
    if (animated) {
        _waterImageView.hidden = YES;
    } else {
        _waterImageView.hidden = NO;
    }
}

- (void)updateLeftTime:(nonnull NSString *)leftTime {
    if (_playerType == PlayerNormal) {
        _leftLabel.text = leftTime;
        NSArray *arr = [leftTime componentsSeparatedByString:@":"];
        __block NSInteger secs = 0;
        [arr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            secs += [obj integerValue] * pow(10, idx - 1);
        }];
        if (secs == 10) {
            UALog(@"[PlayerFollowView again]%@", leftTime);
            [self.playerFollowView showFollowPlayerViewAnimaiton:YES];
        }
    } else if (_playerType == PlayerAd) {
        if ([self.playerControlDelegate respondsToSelector:@selector(currentTime)] && [self.playerControlDelegate respondsToSelector:@selector(duration)]) {
            NSInteger currentSec = (NSInteger) [self.playerControlDelegate currentTime];
            NSInteger duration = (NSInteger) [self.playerControlDelegate duration];
            [_jumpBtn setTitle:[NSString stringWithFormat:@"%@%zdS", [self decorateCountDownByJumpType], duration - currentSec] forState:UIControlStateNormal];
            [_jumpBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo([_jumpBtn.titleLabel.text size4size:CGSizeMake(CGFLOAT_MAX, 25) font:[UIFont systemFontOfSize:12]].width + 20);
            }];
            [_jumpBtn layoutIfNeeded];
            if (duration > 0 && duration - currentSec <= 1) {
                if ([self.playerNormalViewDelegate respondsToSelector:@selector(jumpPreAd:duration:)]) {
                    [self.playerNormalViewDelegate jumpPreAd:NO duration:currentSec];
                }
            }
        }

    } else if (_playerType == PlayerBaiduAd) {
        //no implement here
    } else {
        //ignore
    }
}

- (void)updateRightTime:(nonnull NSString *)rightTime {
    if (_playerType == PlayerNormal) {
        _rightLabel.text = rightTime;
    } else {

    }
}

- (void)updatePlayPauseState:(BOOL)isPlay {
    [self showPlayBtnPlay:isPlay];
}

- (void)updateProgress:(CGFloat)progress {
    [_playerProgress updateProgress:progress];
    [_bottomPlayerProgress updateProgress:progress];
}

- (void)updateBufferProgress:(CGFloat)progress {
    [_playerProgress updateBufferProgress:progress];
    [_bottomPlayerProgress updateBufferProgress:progress];
}

- (BOOL)canRotate {
    return YES;
}

#pragma mark -
#pragma mark  PlayerActionDelegate

- (void)addTapGesture {
    if (_tapGesture) return;
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    _tapGesture.numberOfTapsRequired = 1;
    [_touchView addGestureRecognizer:_tapGesture];
}

- (void)removeTapGesture {
    [_touchView removeGestureRecognizer:_tapGesture];
    _tapGesture = nil;
}

- (void)addPanGesture {
    if (_playerType == PlayerAd || _playerType == PlayerBaiduAd) return;
    if (_panGesture) return;
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
    [_touchView addGestureRecognizer:_panGesture];

}

- (void)removePanGesture {
    [_touchView removeGestureRecognizer:_panGesture];
    _panGesture = nil;
}


#pragma mark -

- (void)fadeHiddenControlViewAnimation:(NSNumber *)animate {
    if (animate.boolValue) {
        @weakify(self);
        [UIView animateWithDuration:.5 animations:^{
            @strongify(self);
            [self userCustomMake:0.0];
        }];
    } else {
        [self userCustomMake:0.0];
    }
}


- (void)fadeShowControlViewAnimation:(NSNumber *)animate {
    if (animate.boolValue) {
        @weakify(self);
        [UIView animateWithDuration:.3 animations:^{
            @strongify(self);
            [self userCustomMake:1.0];
        }];
    } else {
        [self userCustomMake:1.0];
    }
}

- (void)userCustomMake:(float)alpha {
    if (_playerType == PlayerNormal) {
        _jumpBtn.alpha = 0;
    } else {
        _jumpBtn.alpha = 1;
        alpha = 0;
    }
    if (_lockBtn.selected) {
        alpha = 0.0;
    }

    _moreBtn.alpha = alpha;
    _playerProgress.alpha = alpha;

    if (alpha > 0.9) {
        _bottomPlayerProgress.alpha = 0.0;
    } else {
        _bottomPlayerProgress.alpha = 1.0;
    }
    _leftLabel.alpha = alpha;
    _rightLabel.alpha = alpha;
    _fullScreenBtn.alpha = alpha;
    _topControlView.alpha = alpha;
    _bottomControlView.alpha = alpha;
    if (self.playerStyle == PlayerStyleSizeClassRegularHalf) {
        _backBtn.alpha = 1.0;
        _titleLabel.alpha = 0;
        _definitionBtn.alpha = 0;
        _airplayBtn.alpha = alpha;
        _shareBtn.alpha = 0;
        _downloadBtn.alpha = 0;
        _collectionBtn.alpha = 0;
        _qudanBtn.alpha = 0.0;
        _lockBtn.alpha = 0.0;
        _loopBtn.alpha = alpha;
        _playPauseBtn.alpha = 0.0;
        _portraitPlayPauseBtn.alpha = alpha;
        _nextBtn.alpha = 0.0;
    } else {
        _titleLabel.alpha = alpha;
        _airplayBtn.alpha = 0;
        _definitionBtn.alpha = alpha;
        _shareBtn.alpha = alpha;
        _downloadBtn.alpha = alpha;
        _collectionBtn.alpha = alpha;
        _qudanBtn.alpha = alpha;
        _loopBtn.alpha = 0.0;
        if (_lockBtn.selected) {
            _backBtn.alpha = 0.0;
            [self showAndThenHiddenLockAniamtion];
        } else {
            _backBtn.alpha = 1.0;
            _lockBtn.alpha = alpha;
        }

        if (self.playerStyle == PlayerStyleSizeClassCompact) {
            _playPauseBtn.alpha = alpha;
            _portraitPlayPauseBtn.alpha = 0.0;
            _nextBtn.alpha = alpha;
        } else {
            _playPauseBtn.alpha = 0.0;
            _portraitPlayPauseBtn.alpha = alpha;
            _nextBtn.alpha = 0.0;
        }
    }
}

- (void)showAndThenHiddenLockAniamtion {
    _lockBtn.alpha = 1.0;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeHiddenLockAnimation:) object:@(YES)];
    [self performSelector:@selector(fadeHiddenLockAnimation:) withObject:@(YES) afterDelay:_k_AV_WillHideTime];
}

- (void)fadeHiddenLockAnimation:(NSNumber *)animation {
    _lockBtn.alpha = 0.0;
}

- (void)fadeShowAndThenHiddenAnimation {
    [self fadeShowControlViewAnimation:@(YES)];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeHiddenControlViewAnimation:) object:@(YES)];
    [self performSelector:@selector(fadeHiddenControlViewAnimation:) withObject:@(YES) afterDelay:_k_AV_WillHideTime];
}


- (void)tapClick {
    if (_playerType == PlayerAd) {
        if ([self.playerNormalViewDelegate respondsToSelector:@selector(beforeJumpShowAdInfo)]) {
            BOOL needShow = [self.playerNormalViewDelegate beforeJumpShowAdInfo];
            if (!needShow) {
                [self jumppreAd];
                if ([self.playerNormalViewDelegate respondsToSelector:@selector(jump2AdContent)]) {
                    [self.playerNormalViewDelegate jump2AdContent];
                }
            } else {
                if ([self.playerNormalViewDelegate respondsToSelector:@selector(showAdJumpInfo)]) {
                    [self.playerNormalViewDelegate showAdJumpInfo];
                }
            }
        }
    } else if (_playerType == PlayerBaiduAd) {
        //TODO:: baidu click
    } else {
        if (_isControlUIShow) {
            [self fadeHiddenControlViewAnimation:@(YES)];
        } else {
            [self fadeShowAndThenHiddenAnimation];
        }
        _isControlUIShow = !_isControlUIShow;
    }
}

- (void)onPanGesture:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (_isControlUIShow) {
                [self fadeShowControlViewAnimation:@(NO)];
            }

            if ([self.playerNormalViewDelegate respondsToSelector:@selector(playerStatusPause)]) {
                [self.playerNormalViewDelegate playerStatusPause];
            }

            _panOrigin = [panGesture locationInView:self];
            _timeSliding = floor([self.playerControlDelegate currentTime]);
        }
            break;
        case UIGestureRecognizerStateChanged: {
            if (panGesture.numberOfTouches != 1) {
                // pinch 时 单指不动 另一指移动 也可能触发
                return;
            }
            //矢量  带有方向 速度
            CGPoint velocityPoint = [panGesture velocityInView:self];
            //相对于起始位置计算移动距离 (当转换方向,但是位置未跨越起始位置,正负值 没有变化)
            //        CGPoint panDiffPoint = [panGestureRecognizer translationInView:self.view];
            //重新设置 视频相关属性
            [self resetPlayerAttributeSettingWithPanTransPoint:velocityPoint];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            self.hobbleStartTimeInterval = 0;
            if ([self.playerControlDelegate respondsToSelector:@selector(seekSeconds:)] && _isWillSeeking) {
                [self.playerControlDelegate seekSeconds:(CGFloat) _timeSliding];
                [self fadeShowAndThenHiddenAnimation];
            }

            _isWillSeeking = NO;
            _isChangingBright = NO;
            _ischangingVolume = NO;
            [MCMediaNotify dismiss];

        }
            break;
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        default:;
            break;
    }
}


#pragma mark  调节  进度 亮度 声音设置

- (void)resetPlayerAttributeSettingWithPanTransPoint:(CGPoint)panTransPoint {
    //滑动轨迹与水平线夹角在正负45度，都认为是水平滑动，超过45度，就认为是垂直滚动。
    //fabs计算|x|, 当x不为负时返回x，否则返回-x
    if ((fabs(panTransPoint.y) / fabs(panTransPoint.x)) <= 1) {
        if (fabs(panTransPoint.x) < _k_AV_offsetChoseDirection) {
            return;
        }
        // 判断角度     tan(45),这里需要通过正负来判断手势方向
        //进度
        [self resetVideorogressWithPanTransPoint:panTransPoint];
    } else {
        if (fabs(panTransPoint.y) < _k_AV_offsetChoseDirection) {
            return;
        }
        //缓存列表直接打开横屏 获取宽度正常 / 竖屏下获取宽度正常 ; 竖屏切换到横屏 获取宽度异常
        float middleX = CGRectGetMidX(self.frame);
        if (_panOrigin.x < middleX) {
            //亮度
            [self resetBrightnessWithPanTransPoint:panTransPoint];
        } else {
            //声音
            [self resetVolumeWithPanTransPoint:panTransPoint];
        }

    }
}

// 调节亮度
- (void)resetBrightnessWithPanTransPoint:(CGPoint)panTransPoint {
    if (_isWillSeeking || _ischangingVolume) {
        return;
    }
    float brightness = 0;
    if (panTransPoint.y < 0) {
        //上
        brightness = MIN(1., [UIScreen mainScreen].brightness - 0.0001 * panTransPoint.y);
    } else {
        //下
        brightness = MAX(0, [UIScreen mainScreen].brightness - 0.0001 * panTransPoint.y);
    }
    [UIScreen mainScreen].brightness = brightness;
    [MCMediaNotify showImage:[UIImage imageNamed:@"video_brightness"] message:[NSString stringWithFormat:@"%.f%%", brightness * 100] mediaNotifyType:MediaBrightness inView:self];
    _isChangingBright = YES;
}

//调整进度
- (void)resetVideorogressWithPanTransPoint:(CGPoint)panTransPoint {
    if (_isChangingBright || _ischangingVolume || [self.playerControlDelegate duration] <= 0.0) {
        return;
    }

    double duration = [self.playerControlDelegate duration];
    _timeSliding += 0.01 * panTransPoint.x;
    if (panTransPoint.x < 0) {
        //后退
        _timeSliding = MAX(_timeSliding, 0);
        [MCMediaNotify showImage:[UIImage imageNamed:@"video_retreat"] message:[NSString stringWithFormat:@"%@/%@", [self stringFormattedTimeFromSeconds:&_timeSliding], [self stringFormattedTimeFromSeconds:&duration]] mediaNotifyType:MediaProgress inView:self];
    } else {
        _timeSliding = MIN(_timeSliding, duration);//video_forward
        [MCMediaNotify showImage:[UIImage imageNamed:@"video_forward"]
                         message:[NSString stringWithFormat:@"%@/%@", [self stringFormattedTimeFromSeconds:&_timeSliding], [self stringFormattedTimeFromSeconds:&duration]] mediaNotifyType:MediaProgress inView:self];
    }
    _isWillSeeking = YES;
}

//调控声音
- (void)resetVolumeWithPanTransPoint:(CGPoint)panTransPoint {
    if (_isChangingBright || _isWillSeeking) {
        return;
    }
    MPMusicPlayerController *mp = [MPMusicPlayerController applicationMusicPlayer];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (panTransPoint.y < 0) {
        //上
        mp.volume = MIN(1, mp.volume - 0.0001 * panTransPoint.y);
        //            [_videoPlayer setVolume:MIN(1, mp.volume - 0.001 * panTransPoint.y)];
    } else {
        //下
        mp.volume = MAX(0, mp.volume - 0.0001 * panTransPoint.y);
    }
#pragma clang diagnostic pop
    _ischangingVolume = YES;
}

- (NSString *)stringFormattedTimeFromSeconds:(double *)seconds {
    static NSDateFormatter *formatter = nil;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:*seconds];
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    if (*seconds >= 3600) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }

    NSString *string = nil;

    string = [formatter stringFromDate:date];

    return string;
}

#pragma mark - action

- (void)btnBackClick {
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(playerPopViewController)]) {
        [self.playerNormalViewDelegate playerPopViewController];
    }
}

- (void)btnAirPlayClick {
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(showAirplay)]) {
        [self.playerNormalViewDelegate showAirplay];
    }
}

- (void)btnShareClick {
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(showShareView)]) {
        [self.playerNormalViewDelegate showShareView];
    }
}


- (void)btnMoreClick {
    _playerRateBoard.hidden = NO;
    if ([self.playerControlDelegate respondsToSelector:@selector(playRate)]) {
        [_playerRateBoard selectRate:[self.playerControlDelegate playRate]];
    }
    [_playerRateBoard layoutIfNeeded];
}

- (void)btnDownloadClick {
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(actionDownload)]) {
        [self.playerNormalViewDelegate actionDownload];
    }
}

- (void)btnCollectionClick {
    if (_collectionBtn.selected) {
        if ([self.playerNormalViewDelegate respondsToSelector:@selector(cancelCollectionBlock:)]) {
            @weakify(self);
            [self.playerNormalViewDelegate cancelCollectionBlock:^(BOOL success) {
                @strongify(self);
                self->_collectionBtn.selected = NO;
            }];
        }
    } else {
        if ([self.playerNormalViewDelegate respondsToSelector:@selector(collectionBlock:)]) {
            @weakify(self);
            [self.playerNormalViewDelegate collectionBlock:^(BOOL success) {
                @strongify(self);
                self->_collectionBtn.selected = YES;
            }];
        }
    }
}

- (void)btnLoopClick {
    _loopBtn.selected = !_loopBtn.selected;
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(changeLoop:)]) {
        [self.playerNormalViewDelegate changeLoop:_loopBtn.selected];
    }
    [_playerRateBoard circle:_loopBtn.selected];
}

- (void)playerPauseViewPlay {
    if ([self.playerControlDelegate respondsToSelector:@selector(play)]) {
        [self.playerControlDelegate play];
    }
}

- (void)closeAndAddPanGesture {
    [self addPanGesture];
}


- (void)btnPlayPauseClick {
    _playPauseBtn.selected = !_playPauseBtn.selected;
    _portraitPlayPauseBtn.selected = _playPauseBtn.selected;
    if (!_playPauseBtn.selected) {
        if ([self.playerControlDelegate respondsToSelector:@selector(play)]) {
            [self.playerControlDelegate play];
        }
        if ([self.playerNormalViewDelegate respondsToSelector:@selector(logPlay)]) {
            [self.playerNormalViewDelegate logPlay];
        }
    } else {
        if ([self.playerControlDelegate respondsToSelector:@selector(pause)]) {
            [self.playerControlDelegate pause];
        }

        if ([self.playerNormalViewDelegate respondsToSelector:@selector(playerStatusPause)]) {
            [self.playerNormalViewDelegate playerStatusPause];
        }
        if ([self.playerNormalViewDelegate respondsToSelector:@selector(logPause)]) {
            [self.playerNormalViewDelegate logPause];
        }
    }
}

- (void)nextBtnClick {
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(playNextVideo)]) {
        [self.playerNormalViewDelegate playNextVideo];
    }
}

- (void)btnFullClick {
    _fullScreenBtn.selected = !_fullScreenBtn.selected;
    if (_fullScreenBtn.selected) {
        if ([self.playerNormalViewDelegate respondsToSelector:@selector(change2FullScreen)]) {
            [self.playerNormalViewDelegate change2FullScreen];
        }
    } else {
        if ([self.playerNormalViewDelegate respondsToSelector:@selector(change2Half)]) {
            [self.playerNormalViewDelegate change2Half];
        }
    }
}

- (void)btnDefinitionClick {
    //show DefinitionView
    [self definitionView];
}

- (void)btnQudanClick {
    [self qudanListView];
}

- (void)btnJumpAdClick {
    switch (_adJumpType) {
        case PreVideoNotJump: {
            //不让跳
        }
            break;
        case PreVideoAllCanJump: {
            [self jumppreAd];
        }
            break;
        case PreVideoLoginCanJump: {
            @weakify(self);
            [LoginHelper isLoginWithSource:@"" spos:@"" loginSuccess:^(BOOL accountSuccess, BOOL imSuccess, BOOL cancel) {
                if (accountSuccess) {
                    @strongify(self);
                    [self jumppreAd];
                }
            }];
        }
            break;
        case PreVideoJumpOnlyDownload : {
            if ([self.playerNormalViewDelegate respondsToSelector:@selector(beforeJumpShowAdInfo)]) {
                BOOL needShow = [self.playerNormalViewDelegate beforeJumpShowAdInfo];
                if (!needShow) {
                    [self jumppreAd];
                    if ([self.playerNormalViewDelegate respondsToSelector:@selector(jump2AdContent)]) {
                        [self.playerNormalViewDelegate jump2AdContent];
                    }
                } else {
                    if ([self.playerNormalViewDelegate respondsToSelector:@selector(showAdJumpInfo)]) {
                        [self.playerNormalViewDelegate showAdJumpInfo];
                    }
                }
            }
        }
            break;
        default: {
            [self jumppreAd];
        }
            break;
    }
}

- (void)btnLockClick {
    _lockBtn.selected = !_lockBtn.selected;
    [self lockScreen:_lockBtn.selected];
}

- (void)jumppreAd {
    if ([_playerNormalViewDelegate respondsToSelector:@selector(jumpPreAd:duration:)] && [self.playerControlDelegate respondsToSelector:@selector(currentTime)]) {
        if ([self.playerNormalViewDelegate respondsToSelector:@selector(isNotVideoPre)]) {
            BOOL isNotVideoPre = [self.playerNormalViewDelegate isNotVideoPre];
            if (!isNotVideoPre) {
                [_playerNormalViewDelegate jumpPreAd:YES duration:(int) [self.playerControlDelegate currentTime]];
            } else {
                [_playerNormalViewDelegate jumpPreAd:YES duration:_playerPreAdView.originSumOfDuraion - _playerPreAdView.sumOfDuration];
            }
        }
    }
}

- (void)updateBulletHelperDelegate:(id <FXDanmakuDelegate>)delegate {
    _playerBulletView.delegate = delegate;
}

- (id <BulletHelperDelegate>)bulletHelperImpDelegate {
    return _playerBulletView;
}


#pragma  mark -

- (void)changeRate:(CGFloat)rate {
    if ([self.playerControlDelegate respondsToSelector:@selector(playRate:)]) {
        [self.playerControlDelegate playRate:rate];
    }
}

- (void)laterPlay {
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(laterPlay)]) {
        [self.playerNormalViewDelegate laterPlay];
    }
}

- (void)showAirplay {
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(showAirplay)]) {
        [self.playerNormalViewDelegate showAirplay];
    }
}

- (void)actionFeedBack {
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(actionFeedBack)]) {
        [self.playerNormalViewDelegate actionFeedBack];
    }
}

- (void)changeCircle:(BOOL)isCircle {
    _loopBtn.selected = isCircle;
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(changeLoop:)]) {
        [self.playerNormalViewDelegate changeLoop:isCircle];
    }

}

- (void)feedBack {
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(feedBack)]) {
        [self.playerNormalViewDelegate feedBack];
    }
}

#pragma mark -

- (void)change2Normal {
    self.definitionType = DTNormal;
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(changeDefinitionRecordHistory)]) {
        [self.playerNormalViewDelegate changeDefinitionRecordHistory];
    }
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(changeDefinition:)]) {
        [self.playerNormalViewDelegate changeDefinition:DTNormal];
    }
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(changeDefinitionSaveChange:)]) {
        [self.playerNormalViewDelegate changeDefinitionSaveChange:DTNormal];
    }
    [_definitionBtn setTitle:@"标清" forState:UIControlStateNormal];
    [self removeDefinitionView];
}

- (void)change2Hight {
    self.definitionType = DTHight;
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(changeDefinitionRecordHistory)]) {
        [self.playerNormalViewDelegate changeDefinitionRecordHistory];
    }
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(changeDefinition:)]) {
        [self.playerNormalViewDelegate changeDefinition:DTHight];
    }

    if ([self.playerNormalViewDelegate respondsToSelector:@selector(changeDefinitionSaveChange:)]) {
        [self.playerNormalViewDelegate changeDefinitionSaveChange:DTHight];
    }

    [_definitionBtn setTitle:@"高清" forState:UIControlStateNormal];
    [self removeDefinitionView];
}

- (void)change2UHD {
    self.definitionType = DTUHight;
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(changeDefinitionRecordHistory)]) {
        [self.playerNormalViewDelegate changeDefinitionRecordHistory];
    }
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(changeDefinition:)]) {
        [self.playerNormalViewDelegate changeDefinition:DTUHight];
    }

    if ([self.playerNormalViewDelegate respondsToSelector:@selector(changeDefinitionSaveChange:)]) {
        [self.playerNormalViewDelegate changeDefinitionSaveChange:DTUHight];
    }
    [_definitionBtn setTitle:@"超清" forState:UIControlStateNormal];
    [self removeDefinitionView];
}

- (void)log2HobbleChange2Normal {
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(changeDefinitionRecordHistory)]) {
        [self.playerNormalViewDelegate changeDefinitionRecordHistory];
    }
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(log2HobbleChange2Normal)]) {
        [self.playerNormalViewDelegate log2HobbleChange2Normal];
    }
}


- (void)removeDefinitionView {
    [_definitionView removeFromSuperview];
    _definitionView = nil;
}

- (void)removeHobbleMentionView {
    [_hobbleMentionView removeFromSuperview];
    _hobbleMentionView = nil;
}

- (void)removeHobbleQudianMentionView {
    [_hobbleQudianMentionView removeFromSuperview];
    _hobbleQudianMentionView = nil;
}

- (void)removeQudanListView {
    [_qudanListView removeFromSuperview];
    _qudanListView = nil;
}

- (void)removePlayerFollowView {
    [_playerFollowView removeFromSuperview];
    _playerFollowView = nil;
}


- (void)updateFullScreenBtnStatus:(BOOL)fullScreen {
    _fullScreenBtn.selected = fullScreen;
}

- (void)updateFollow:(BOOL)follow {
    if (_playerFollowView) {
        [_playerFollowView updateSeleted:follow];
    }

}


- (void)updateDefinitionNormal:(BOOL)hasNormal HD:(BOOL)hasHD UHD:(BOOL)hasUHD {
    self.hasNormal = hasNormal;
    self.hasHD = hasHD;
    self.hasUHD = hasUHD;
}

- (void)updateCurrentDefinition:(DefinitionType)definitionType {
    self.definitionType = definitionType;
    [_definitionBtn setTitle:({
        NSString *name = @"标清";
        switch (definitionType) {
            case DTNormal: {
                if (_hasNormal) {
                    name = @"标清";
                }
            }
                break;
            case DTHight : {
                if (_hasHD) {
                    name = @"高清";
                } else if (_hasNormal) {
                    name = @"标清";
                }
            }
                break;
            case DTUHight: {
                if (_hasUHD) {
                    name = @"超清";
                } else if (_hasHD) {
                    name = @"高清";
                } else if (_hasNormal) {
                    name = @"标清";
                }
            }
                break;
        }
        name;
    })              forState:UIControlStateNormal];

}

- (void)updateHasQudan:(BOOL)hasQudan {
    _qudanBtn.hidden = !hasQudan;
    [self setNeedsUpdateConstraints];
    [self needsUpdateConstraints];
    [self layoutIfNeeded];
}

- (void)lockScreen:(BOOL)isLock {
    if (isLock) {
        [self removePanGesture];
        [self userCustomMake:0.0];
    } else {
        [self addPanGesture];
        [self fadeShowAndThenHiddenAnimation];
    }
}

- (BOOL)isLock {
    return _lockBtn.selected;
}

- (void)showCanLoop:(BOOL)isLoop {
    _loopBtn.hidden = !isLoop;
    [_playerRateBoard canShowCircle:isLoop];
}

- (BOOL)isLoop {
    if (_loopBtn.hidden) {
        return NO;
    }
    return _loopBtn.selected;
}

- (void)resetLoop {
    _loopBtn.selected = NO;
    [_playerRateBoard circle:NO];
}

- (void)refreshDots:(NSArray<SnapDto *> *)dtos duration:(CGFloat)duration {
    if (duration <= 1.0f) {
        return;
    }

    NSMutableArray<__SliderPointDto *> *sliderPointDtos = [NSMutableArray array];
    for (SnapDto *dto in dtos) {
        __SliderPointDto *sliderPointDto = [[__SliderPointDto alloc] init];
        sliderPointDto.entityId = dto.entityId;
        sliderPointDto.snapDto = dto;
        sliderPointDto.xStartRate = [@([dto.startTime doubleValue] / (duration * 1000.0f)) floatValue];
        [sliderPointDtos addObject:sliderPointDto];
    }

    [_playerProgress refreshDots:sliderPointDtos];
}

- (void)updateMention:(NSString *)mention xRate:(CGFloat)xRate showSecs:(CGFloat)showSecs {
    if (![StringUtils hasText:mention]) {
        [self removeHobbleQudianMentionView];
        return;
    }
    [self.hobbleQudianMentionView updateMention:mention];
    self.hobbleQudianMentionView.xRate = xRate;
    [self updateQudianMentionFrame];

    [self disposeQudianMentionView];
    showSecs = showSecs < 5.0f ? 5.0f : showSecs;
    @weakify(self);
    self.hobbleQudianDispose = [[RACScheduler mainThreadScheduler] afterDelay:showSecs schedule:^{
        @strongify(self);
        [self removeHobbleQudianMentionView];
    }];
}

- (void)updateQudianMentionFrame {
    CGFloat width = CGRectGetWidth(_playerProgress.frame);
    CGSize size = [_hobbleQudianMentionView.mentionLabel sizeThatFits:CGSizeMake(width, 12)];
    CGFloat x = ({
        CGFloat x1 = _hobbleQudianMentionView.xRate * width - size.width / 2.0f;
        x1;
    });

    x += CGRectGetMinX(_playerProgress.frame);

    CGFloat bottomMagain = self.playerStyle == PlayerStyleSizeClassCompact ? 80.0f : 60.0f;
    _hobbleQudianMentionView.frame = CGRectMake(x, self.frame.size.height - bottomMagain, size.width + 20, 30);

    [_playerProgress refreshDotsFrame];
}


#pragma mark -AirplayPlayerDelegate

- (void)showAirplayFailed:(NSString *)title {
    @weakify(self);
    [self mainThread:^{
        @strongify(self);
        self.playerTerminalView.hidden = NO;
        [self.playerTerminalView updatePlayerTerminal:PlayerPlayingUsingAirplay title:title];
        if ([self.playerControlDelegate respondsToSelector:@selector(pause)]) {
            [self.playerControlDelegate pause];
        }
    }];

}

- (void)showAirplaySuccess:(NSString *)title {
    @weakify(self);
    [self mainThread:^{
        @strongify(self);
        self.playerTerminalView.hidden = NO;
        [self.playerTerminalView updatePlayerTerminal:PlayerPlayingUsingAirplay title:title];
        if ([self.playerControlDelegate respondsToSelector:@selector(pause)]) {
            [self.playerControlDelegate pause];
        }
    }];
}

- (void)mainThread:(void (^)())callBack {
    if ([[NSThread currentThread] isMainThread]) {
        callBack();
    } else {
        [[GCDQueue mainQueue] execute:^{
            callBack();
        }];
    }
}

- (void)dragProgressToProgress:(float)progress {
    if ([self.playerControlDelegate respondsToSelector:@selector(seekSeconds:)] && [self.playerControlDelegate respondsToSelector:@selector(duration)]) {
        [self.playerControlDelegate seekSeconds:self.playerControlDelegate.duration * progress];
    }
    _isWait2Seek = NO;

    self.hobbleStartTimeInterval = 0;
}

- (void)controlProgressStartDragSlider {
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(playerStatusPause)]) {
        [self.playerNormalViewDelegate playerStatusPause];
    }
    _isWait2Seek = YES;

    self.hobbleStartTimeInterval = 0;
}

- (void)controlProgressEndDragSlider {

    self.hobbleStartTimeInterval = 0;
}

- (void)sliderPointClick:(SnapDto *)snapDto {
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(sliderPointClick:)]) {
        [self disposeHobbleView];
        [self.playerNormalViewDelegate sliderPointClick:snapDto];
    }
}

#pragma mark - PlayerPreAdViewDelegate

- (void)playerStartUnionAd:(MMAdDto *)adDto {
    UALog(@"[Baidu][Player]Start[%@]", adDto);
}

- (void)playerEndUnionAd:(MMAdDto *)adDto {
    UALog(@"[Baidu][Player]End[%@]", adDto);
}

- (void)playerUnionCountDown:(NSUInteger)secs {
    UALog(@"[Baidu][Player]current[%zd]", secs);
    [_jumpBtn setTitle:[NSString stringWithFormat:@"%@%zdS", [self decorateCountDownByJumpType], secs] forState:UIControlStateNormal];
    [_jumpBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([_jumpBtn.titleLabel.text size4size:CGSizeMake(CGFLOAT_MAX, 25) font:[UIFont systemFontOfSize:12]].width + 20);
    }];
    [_jumpBtn layoutIfNeeded];
}

- (void)playerFinishAllUnionAds {
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(changeDefinition:)]) {
        [self.playerNormalViewDelegate changeDefinition:self.definitionType];
    }
}

@end


@implementation _DefinitionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGSize size = CGSizeMake(50, 25);
        CGFloat xSpace = 20;

        CGFloat x = frame.size.width / 2;
        CGFloat centerY = frame.size.height / 2;

        self.bgView = ({
            UIView *view = [[UIView alloc] initWithFrame:self.bounds];
            view.backgroundColor = [WQColorStyle blackColor];
            view.alpha = .8;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
            [view addGestureRecognizer:tap];
            [self addSubview:view];
            view;
        });

        self.titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x - 140, (CGFloat) (centerY - 7.5), 60, 15)];
            label.text = @"清晰度";
            label.textColor = [UIColor colorWithHex:0xb2b2b2];
            label.font = [UIFont systemFontOfSize:14];
            [self addSubview:label];
            label;
        });

        self.normalBtn = ({
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x - 80, (CGFloat) (centerY - (CGFloat) size.height / 2.0), size.width, size.height)];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[WQColorStyle shallowBlueColor] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(normalBtnClick) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitle:@"标清" forState:UIControlStateNormal];
            [self addSubview:btn];
            btn;
        });


        self.hightBtn = ({
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x - 8, (CGFloat) (centerY - size.height / 2.0), size.width, size.height)];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[WQColorStyle shallowBlueColor] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(hightBtnClick) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitle:@"高清" forState:UIControlStateNormal];
            [self addSubview:btn];
            btn;
        });


        self.uhdBtn = ({
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x + 60, (CGFloat) (centerY - size.height / 2.0), size.width, size.height)];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[WQColorStyle shallowBlueColor] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(uhdBtnClick) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitle:@"超清" forState:UIControlStateNormal];
            [self addSubview:btn];
            btn;
        });
    }
    return self;
}

- (void)selectDefinitionType:(DefinitionType)type {

    [self change2BtnSelected:YES btn:_normalBtn];
    [self change2BtnSelected:NO btn:_hightBtn];
    [self change2BtnSelected:NO btn:_uhdBtn];

    switch (type) {
        case DTNormal: {
            if (_hasNormal) {
                [self change2BtnSelected:YES btn:_normalBtn];
                [self change2BtnSelected:NO btn:_hightBtn];
                [self change2BtnSelected:NO btn:_uhdBtn];
            }
        }
            break;
        case DTHight: {
            if (_hasHD) {
                [self change2BtnSelected:NO btn:_normalBtn];
                [self change2BtnSelected:YES btn:_hightBtn];
                [self change2BtnSelected:NO btn:_uhdBtn];
            }
        }
            break;
        case DTUHight: {
            if (_hasUHD) {
                [self change2BtnSelected:NO btn:_normalBtn];
                [self change2BtnSelected:NO btn:_hightBtn];
                [self change2BtnSelected:YES btn:_uhdBtn];
            } else if (_hasHD) {
                [self change2BtnSelected:NO btn:_normalBtn];
                [self change2BtnSelected:YES btn:_hightBtn];
                [self change2BtnSelected:NO btn:_uhdBtn];
            }
        }
            break;
    }
}

- (void)updateDefinitionNormal:(BOOL)hasNormal HD:(BOOL)hasHD UHD:(BOOL)hasUHD {

    self.hasNormal = hasNormal;
    self.hasHD = hasHD;
    self.hasUHD = hasUHD;

    _normalBtn.enabled = hasNormal;
    _hightBtn.enabled = hasHD;
    _uhdBtn.enabled = hasUHD;


    [_normalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_hightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_uhdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    if (!hasNormal) {
        [self change2BtnSelected:NO btn:_normalBtn];
        [_normalBtn setTitleColor:[UIColor colorWithHex:0x808080] forState:UIControlStateNormal];
    }

    if (!hasHD) {
        [self change2BtnSelected:NO btn:_hightBtn];
        [_hightBtn setTitleColor:[UIColor colorWithHex:0x808080] forState:UIControlStateNormal];
    }

    if (!hasUHD) {
        [self change2BtnSelected:NO btn:_uhdBtn];
        [_uhdBtn setTitleColor:[UIColor colorWithHex:0x808080] forState:UIControlStateNormal];
    }
}


- (void)change2BtnSelected:(BOOL)isSelected btn:(UIButton *)btn {
    if (isSelected) {
        [ViewShapeMask cornerView:btn radius:12.5 border:1 color:[UIColor whiteColor]];
    } else {
        [ViewShapeMask cornerView:btn radius:12.5 border:0 color:nil];
    }
}

- (void)tapClick {
    [self removeFromSuperview];
}

- (void)hightBtnClick {
    [self selectDefinitionType:DTHight];
    if ([_delegate respondsToSelector:@selector(change2Hight)]) {
        [_delegate change2Hight];
    }
    [self wifiChangeUserSetting:DTHight];
}

- (void)normalBtnClick {
    [self selectDefinitionType:DTNormal];
    if ([_delegate respondsToSelector:@selector(change2Normal)]) {
        [_delegate change2Normal];
    }
    [self wifiChangeUserSetting:DTNormal];
}

- (void)uhdBtnClick {
    [self selectDefinitionType:DTUHight];
    if ([_delegate respondsToSelector:@selector(change2UHD)]) {
        [_delegate change2UHD];
    }
    [self wifiChangeUserSetting:DTUHight];
}

- (void)wifiChangeUserSetting:(DefinitionType)definitionType {
    ReachabilityStatus netStatus = [[ReachabilitySession share] netWorkStatus];
    if (netStatus == RealStatusViaWiFi) {
        WQUserSetting *setting = [[WQUserSetting sharedInstance] getUserSettingwithUserID:[MMKeyChain openUDID]];
        setting.definitionType = definitionType;
        setting.userSetDefinition = YES;
        [setting saveUserSetting:setting];
    }
}

@end


@implementation _HobbleMentionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _bgView = ({
            UIView *view = [[UIView alloc] initWithFrame:self.bounds];
            view.backgroundColor = [WQColorStyle blackColor];
            view.alpha = .8;
            [ViewShapeMask cornerView:view radius:15 border:0 color:nil];
            [self addSubview:view];
            view;
        });

        _mentionLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:12];
            [self addSubview:label];
            label;
        });

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _bgView.frame = self.bounds;
    _mentionLabel.frame = self.bounds;
}

- (void)tapClick {
    if (self.type == HobbleMentionQudianTitle) {
        return;
    }
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(change2Normal)]) {
        [self.delegate change2Normal];
    }
    ReachabilityStatus netStatus = [[ReachabilitySession share] netWorkStatus];
    if (netStatus == RealStatusViaWiFi) {
        WQUserSetting *setting = [[WQUserSetting sharedInstance] getUserSettingwithUserID:[MMKeyChain openUDID]];
        setting.definitionType = DTNormal;
        setting.userSetDefinition = YES;
        [setting saveUserSetting:setting];
    }
}

- (void)updateBadNet {
    _mentionLabel.attributedText = ({
        NSString *str = @"网络似乎不流畅？切换标清试试";
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
        [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, str.length)];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 10)];
        [text addAttribute:NSForegroundColorAttributeName value:[WQColorStyle waQuBlue] range:NSMakeRange(str.length - 4, 2)];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(str.length - 2, 2)];
        text;
    });
}

- (void)updateMention:(NSString *)mention {
    self.type = HobbleMentionQudianTitle;
    NSMutableAttributedString *attributedString = ({
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:mention];
        [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, mention.length)];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, mention.length)];
        text;
    });

    _mentionLabel.attributedText = nil;
    _mentionLabel.attributedText = attributedString;
}


@end


@implementation _QudanListView
- (instancetype)initWithFrame:(CGRect)frame delegate:(id <_QudanListViewTranslateDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        _bgView = ({
            UIView *view = [[UIView alloc] initWithFrame:self.bounds];
            view.backgroundColor = [WQColorStyle blackColor];
            view.alpha = .8;
            [ViewShapeMask cornerView:view radius:15 border:0 color:nil];
            [self addSubview:view];
            view;
        });

        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(frame.size.width * 0.2, 0, frame.size.width * 0.6, frame.size.height) style:UITableViewStylePlain];
        [self addSubview:self.tableView];
        self.translate = [[_QudanListViewTranslate alloc] initWithEmptyTableView:self.tableView delegate:delegate];
        [self.translate triggerRefresh];

        self.translate.qudanListViewDelegate = self;

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [_bgView addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)tapClick {
    [self removeFromSuperview];
}

- (void)clickCell {
    [self tapClick];
}

@end


@implementation _QudanListViewTranslate

- (void)dealloc {
    [self disposeScroll];
}

- (instancetype)initWithEmptyTableView:(UITableView *)tableView delegate:(id <_QudanListViewTranslateDelegate>)delegate {
    self = [super initWithEmptyTable:tableView];
    if (self) {
        self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.delegate = delegate;
        [self.tableView registerClass:[PlayerQudanLineCell class] forCellReuseIdentifier:[PlayerQudanLineCell reuseIdentifier]];
        [self.tableView registerClass:[MMTableCell class] forCellReuseIdentifier:[MMTableCell identifier]];
    }
    return self;
}

- (void)disposeScroll {
    if (self.dispose) {
        [self.dispose dispose];
        self.dispose = nil;
    }
}

- (void)refresh {
    if (self.isRefresh) {
        return;
    }
    self.isRefresh = YES;
    [self loadData:self.datas.count <= 0];
}

- (void)more {
    if ([self.delegate respondsToSelector:@selector(canLoadMore)]) {
        if ([self.delegate canLoadMore]) {
            [self loadData:NO];
        } else {
            [self stopMore];
        }
    }
}

- (void)loadData:(BOOL)isLocal {
    if ([self.delegate respondsToSelector:@selector(qudanList:)] && [self.delegate respondsToSelector:@selector(localDataRfresh)]) {
        RACSignal *signal = nil;
        if (isLocal) {
            signal = [self.delegate localDataRfresh];
        } else {
            signal = [self.delegate qudanList:self.isRefresh];
        }

        @weakify(self);
        [signal subscribeNext:^(NSArray<MMDto *> *datas) {
            @strongify(self);
            self.isRefresh = NO;
            self.datas = datas;
            if ([self.delegate respondsToSelector:@selector(qudanPlayAtIndex)]) {
                self.currentPlayIndex = [self.delegate qudanPlayAtIndex];
            }

            if ([self.delegate respondsToSelector:@selector(reloadData)]) {
                [self.delegate reloadData];
            }
            [self successStop];

            [self disposeScroll];
            if (isLocal && datas.count > 0 && self.currentPlayIndex < datas.count) {
                @weakify(self);
                self.dispose = [[RACScheduler mainThreadScheduler] afterDelay:.2 schedule:^{
                    @strongify(self);
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentPlayIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                }];
            }
        }               error:^(NSError *error) {
            [self errorStop];
            self.isRefresh = NO;
        }];
    }
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMVideoDto *dto = self.datas[(NSUInteger) indexPath.row];
    if ([dto isVideo]) {
        PlayerQudanLineCell *cell = [tableView dequeueReusableCellWithIdentifier:[PlayerQudanLineCell reuseIdentifier] forIndexPath:indexPath];
        [cell updateTitle:((MMVideoDto *) dto).videoMedia.title];
        [cell updatePlayNow:self.currentPlayIndex == indexPath.row];
        return cell;
    } else {
        MMTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[MMTableCell identifier] forIndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMVideoDto *dto = self.datas[(NSUInteger) indexPath.row];
    if ([dto isVideo]) {
        return [PlayerQudanLineCell staticHeight];
    } else {
        return 0.0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(qudanlistClick:)]) {
        self.currentPlayIndex = (NSUInteger) indexPath.row;
        [self.tableView reloadData];
        [self.delegate qudanlistClick:self.datas[(NSUInteger) indexPath.row]];
    }

    if ([self.qudanListViewDelegate respondsToSelector:@selector(clickCell)]) {
        [self.qudanListViewDelegate clickCell];
    }
}
@end

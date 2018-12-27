//
// Created by majiancheng on 2017/3/17.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "PlayerNormalView.h"

#import <MediaPlayer/MediaPlayer.h>
#import <Masonry.h>

#import "MCPlayerKit.h"
#import "PlayerProgress.h"
#import "PlayerTerminalView.h"
#import "MCMediaNotify.h"
#import "PlayerLoadingView.h"
#import "UIColor+Hex.h"


////////////////////////////////////
@interface PlayerNormalView () <PlayerProgressDelegate>

@property(nonatomic, assign) DefinitionType definitionType;

@property(nonatomic, assign) NSTimeInterval hobbleStartTimeInterval;

@property(nonatomic, assign) BOOL hasNormal;
@property(nonatomic, assign) BOOL hasHD;
@property(nonatomic, assign) BOOL hasUHD;


@end


@implementation PlayerNormalView
- (void)dealloc {
    PKLog(@"[%@]dealloc", NSStringFromClass([self class]));
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeHiddenLockAnimation:) object:@(YES)];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeHiddenControlViewAnimation:) object:@(YES)];
}

- (void)updatePlayerView:(UIView *)drawPlayerView {
    [super updatePlayerView:drawPlayerView];
//    [self sendSubviewToBack:_drawView];
}

- (void)updatePlayerLayer:(CALayer *)layer {
    [super updatePlayerLayer:layer];
}

- (void)updatePlayStyle:(PlayerType)playerType {
    _playerType = playerType;
    if (_playerType != PlayerUnionAd) {
    }
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

    _touchView = [[UIView alloc] init];
    [_containerView addSubview:_touchView];

    _topGradientLayer = ({
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.colors = @[(__bridge id) [UIColor rgba:0x00000099].CGColor, (__bridge id) [UIColor rgba:0x0000005].CGColor];
        layer.locations = @[@(.4)];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(0, 1.0);
        layer.frame = CGRectMake(0, 0, MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height), 50);

        _topControlView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height), 50)];
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
        layer.frame = CGRectMake(0, 0, MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height), 50);
        _bottomControlView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height), 50)];
            [_containerView addSubview:view];
            view.userInteractionEnabled = YES;
            view;
        });
        [_bottomControlView.layer addSublayer:layer];
        layer;
    });

    _backBtn = [[UIButton alloc] init];
    _titleLabel = ({
        UILabel *autoLabel = [UILabel new];
        autoLabel.textColor = [UIColor whiteColor];
        autoLabel.font = [UIFont systemFontOfSize:15];
        [_containerView addSubview:autoLabel];
        autoLabel.textColor = [UIColor whiteColor];
        autoLabel.textAlignment = NSTextAlignmentLeft; // centers text when no auto-scrolling is applied
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
    [_containerView addSubview:_lockBtn];

    {
        UIEdgeInsets inset = UIEdgeInsetsZero;
        _playPauseBtn.imageEdgeInsets = inset;
        _nextBtn.imageEdgeInsets = inset;
        _fullScreenBtn.imageEdgeInsets = inset;;

    }

    [_backBtn setImage:[UIImage imageNamed:@"back_w"] forState:UIControlStateNormal];

    [_moreBtn setImage:[UIImage imageNamed:@"more_whte"] forState:UIControlStateNormal];
    [_airplayBtn setImage:[UIImage imageNamed:@"player_tv"] forState:UIControlStateNormal];

    [_shareBtn setImage:[UIImage imageNamed:@"share_white"] forState:UIControlStateNormal];
    [_downloadBtn setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];

    [_collectionBtn setImage:[UIImage imageNamed:@"favorites_white"] forState:UIControlStateNormal];
    [_collectionBtn setImage:[UIImage imageNamed:@"favorited"] forState:UIControlStateSelected];

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
        DefinitionType definitionType = [PlayerViewConfig sharedInstance].definitionType;
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
    [_definitionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_definitionBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];


    _leftLabel.font = [UIFont systemFontOfSize:10];
    _leftLabel.textColor = [UIColor whiteColor];
    _rightLabel.font = [UIFont systemFontOfSize:10];
    _rightLabel.textColor = [UIColor whiteColor];
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
    [_lockBtn addTarget:self action:@selector(btnLockClick) forControlEvents:UIControlEventTouchUpInside];

    _playerProgress.delegate = self;

    _definitionBtn.alpha = 0.0;
    _shareBtn.alpha = 0.0;
    _titleLabel.alpha = 0.0;
    _playPauseBtn.alpha = 0.0;

    _loadingView = [[PlayerLoadingView alloc] init];
    [self insertSubview:_loadingView atIndex:PlayerLayerLevelLoadingView];

    _waterImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_k_AV_water_image]];
    _waterImageView.alpha = .6f;
    [self insertSubview:_waterImageView atIndex:PlayerLayerLevelWater];

    [self playerTerminalView];
    [self updateLayerIndex];
}

- (void)setPlayerTermailDelegate:(id <PlayerTerminalDelegate>)playerTermailDelegate {
    _playerTermailDelegate = playerTermailDelegate;
    self.playerTerminalView.delegate = playerTermailDelegate;
}

- (void)setPlayerStyle:(PlayerStyle)playerStyle {
    _playerStyle = playerStyle;
    switch (_playerStyle) {
        case PlayerStyleSizeClassCompact: {
            _airplayBtn.alpha = 0.0;
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
        }
            break;
    }

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

- (void)updateLayerIndex {
    [self insertSubview:_waterImageView atIndex:PlayerLayerLevelWater];
    [self insertSubview:_containerView atIndex:PlayerLayerLevelNormalControlBar];
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
}

- (void)updateConstraints {
    [_containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];

    [_touchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self->_containerView);
    }];

    CGFloat top = 0;
    if (self.playerStyle == PlayerStyleSizeClassRegularHalf || self.playerStyle == PlayerStyleSizeClassRegular) {
        top = 15;
    }
    [_backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(top);
        make.left.equalTo(self).offset(0);
        make.width.height.mas_equalTo(35);
    }];

    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self->_backBtn);
        make.left.equalTo(self->_backBtn.mas_right).offset(10);
        make.right.equalTo(self->_collectionBtn.mas_left).offset(-10);
        make.height.mas_equalTo(16);
    }];

    CGFloat btnWidth = 40;
    [_moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(top);
        make.width.height.mas_equalTo(btnWidth);
    }];

    [_airplayBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.playerStyle == PlayerStyleSizeClassRegularHalf) {
            make.right.equalTo(self->_moreBtn.mas_left).offset(-10);
        } else {
            make.right.equalTo(self->_shareBtn.mas_left).offset(-10);
        }
        make.top.equalTo(self->_backBtn);
        make.width.height.mas_equalTo(btnWidth);
    }];

    [_shareBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->_moreBtn.mas_left).offset(-10);
        make.top.equalTo(self->_backBtn);
        make.width.height.mas_equalTo(btnWidth);
    }];


    [_downloadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->_shareBtn.mas_left).offset(-10);
        make.top.equalTo(self->_backBtn);
        make.width.height.mas_equalTo(btnWidth);
    }];

    [_collectionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->_downloadBtn.mas_left).offset(-10);
        make.top.equalTo(self->_backBtn);
        make.width.height.mas_equalTo(btnWidth);
    }];

    [_loopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.width.height.mas_equalTo(bottomHeight);
    }];

    [_portraitPlayPauseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(60);
    }];

    [_nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playPauseBtn.mas_right).offset(10);
        make.centerY.equalTo(_playPauseBtn);
        make.width.height.equalTo(_playPauseBtn);
    }];

    [_leftLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (_playerStyle != PlayerStyleSizeClassCompact) {
            make.left.equalTo(self->_containerView.mas_left).offset(5);
        } else {
            make.left.equalTo(self->_nextBtn.mas_right).offset(5);
        }
        make.centerY.equalTo(self->_playPauseBtn);
    }];


    [_fullScreenBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->_containerView.mas_right).offset(-10);
        make.centerY.equalTo(self->_playPauseBtn);
        make.width.height.mas_equalTo(bottomHeight);
    }];


    [_definitionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->_fullScreenBtn.mas_left).offset(-5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(bottomHeight);
        make.centerY.equalTo(self->_playPauseBtn);
    }];

    [_rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.playerStyle == PlayerStyleSizeClassRegularHalf) {
            make.right.equalTo(self->_fullScreenBtn.mas_left).offset(-5);
        } else {
            make.right.equalTo(self->_definitionBtn.mas_left).offset(-5);
        }
        make.centerY.equalTo(self->_playPauseBtn);
    }];

    [_playerProgress mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_leftLabel.mas_right).offset(5);
        make.bottom.equalTo(self->_containerView.mas_bottom);
        make.top.equalTo(self->_playPauseBtn.mas_top).offset(-10);
        make.right.equalTo(self->_rightLabel.mas_left).offset(-5);
    }];

    [_playerProgress layoutIfNeeded];

    [_bottomPlayerProgress mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_containerView.mas_left);
        make.bottom.equalTo(self->_containerView.mas_bottom);
        make.height.mas_equalTo(2);
        make.right.equalTo(self->_containerView.mas_right);
    }];

    [_bottomPlayerProgress layoutIfNeeded];

    [_loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [_waterImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
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

    [_playerTerminalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];

    [_lockBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
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
    if (_playerType != PlayerNormal || isPlay) {
        [self addPanGesture];
    }
    if (_playerType != PlayerNormal) {
        return;
    }
    if (!isPlay) {
        switch (self.playerStyle) {
            case PlayerStyleSizeClassRegularHalf: {
            }
                break;  ///<  16:9 半屏幕
            case PlayerStyleSizeClassRegular: {
            }
                break;      ///<  竖屏全屏
            case PlayerStyleSizeClassCompact: {
            }

                break;
            default: {
            }
                break;
        }
    }
}

- (void)showLoading {
    if (_playerType == PlayerUnionAd) {
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
            PKLog(@"[PlayerFollowView again]%@", leftTime);
        }
    } else if (_playerType == PlayerAd) {
    } else if (_playerType == PlayerUnionAd) {
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
    if (_playerType == PlayerAd || _playerType == PlayerUnionAd) return;
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
        [UIView animateWithDuration:.5 animations:^{
            [self userCustomMake:0.0];
        }];
    } else {
        [self userCustomMake:0.0];
    }
}


- (void)fadeShowControlViewAnimation:(NSNumber *)animate {
    if (animate.boolValue) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:.3 animations:^{
            [self userCustomMake:1.0];
        }];
    } else {
        [self userCustomMake:1.0];
    }
}

- (void)userCustomMake:(float)alpha {
    if (_playerType == PlayerNormal) {
    } else {
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
                if ([self.playerNormalViewDelegate respondsToSelector:@selector(jump2AdContent)]) {
                    [self.playerNormalViewDelegate jump2AdContent];
                }
            } else {
                if ([self.playerNormalViewDelegate respondsToSelector:@selector(showAdJumpInfo)]) {
                    [self.playerNormalViewDelegate showAdJumpInfo];
                }
            }
        }
    } else if (_playerType == PlayerUnionAd) {
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

- (void)btnMoreClick {
    PKLog(@"btnMoreClick");
}

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

- (void)btnDownloadClick {
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(actionDownload)]) {
        [self.playerNormalViewDelegate actionDownload];
    }
}

- (void)btnCollectionClick {
    if (_collectionBtn.selected) {
        if ([self.playerNormalViewDelegate respondsToSelector:@selector(cancelCollectionBlock:)]) {
            __weak typeof(self) weakSelf = self;
            [self.playerNormalViewDelegate cancelCollectionBlock:^(BOOL success) {
                __strong typeof(self) strongSelf = weakSelf;
                strongSelf->_collectionBtn.selected = NO;
            }];
        }
    } else {
        if ([self.playerNormalViewDelegate respondsToSelector:@selector(collectionBlock:)]) {
            __weak typeof(self) weakSelf = self;
            [self.playerNormalViewDelegate collectionBlock:^(BOOL success) {
                __strong typeof(self) strongSelf = weakSelf;
                strongSelf->_collectionBtn.selected = YES;
            }];
        }
    }
}

- (void)btnLoopClick {
    _loopBtn.selected = !_loopBtn.selected;
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(changeLoop:)]) {
        [self.playerNormalViewDelegate changeLoop:_loopBtn.selected];
    }
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

}

- (void)btnLockClick {
    _lockBtn.selected = !_lockBtn.selected;
    [self lockScreen:_lockBtn.selected];
}

#pragma  mark -

- (void)changeRate:(CGFloat)rate {
    if ([self.playerControlDelegate respondsToSelector:@selector(playRate:)]) {
        [self.playerControlDelegate playRate:rate];
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
}

- (void)log2HobbleChange2Normal {
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(changeDefinitionRecordHistory)]) {
        [self.playerNormalViewDelegate changeDefinitionRecordHistory];
    }
    if ([self.playerNormalViewDelegate respondsToSelector:@selector(log2HobbleChange2Normal)]) {
        [self.playerNormalViewDelegate log2HobbleChange2Normal];
    }
}

- (void)updateFullScreenBtnStatus:(BOOL)fullScreen {
    _fullScreenBtn.selected = fullScreen;
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
}

- (BOOL)isLoop {
    if (_loopBtn.hidden) {
        return NO;
    }
    return _loopBtn.selected;
}

- (void)resetLoop {
    _loopBtn.selected = NO;
}


- (void)mainThread:(void (^)())callBack {
    if ([[NSThread currentThread] isMainThread]) {
        callBack();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callBack) {
                callBack();
            }
        });
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


@end

//
// Created by littleplayer on 16/5/20.
// Copyright (c) 2016 mjc inc. All rights reserved.
//

#import "MCPlayerGeneralTerminalView.h"

#import <MCStyle/MCStyleDef.h>

#import "MCPlayerViewConfig.h"
#import "MCPlayerkitDef.h"


typedef NS_ENUM(NSInteger, PTAirPlayEvent) {
    PTAPQuitAirPlayEvent,
    PTAPAirPlayPlay,
    PTAPAirPlayPause,
    PTAPAirPlayVolumeLarge,
    PTAPAirPlayVolumeSmall
};

@interface MCPlayerGeneralTerminalView ()

@property(nonatomic, strong) UILabel *videoTitle;
@property(nonatomic, strong) UILabel *mentionInfo;
@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property(nonatomic, assign) MCPlayerTerminalState playerSate;

@property(nonatomic, strong) UIButton *quitAirPlayBtn;
@property(nonatomic, strong) UIButton *volumeLargeBtn;
@property(nonatomic, strong) UIButton *volumeSmallBtn;
@property(nonatomic, strong) UIButton *playPauseBtn;

@end

@implementation MCPlayerGeneralTerminalView

- (void)dealloc {
    MCLog(@"[PK]%@ dealloc", NSStringFromClass(self.class));
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self createViews];
    [self addLayout];
    [self addAction];
    [self updateStyle];
    [self showNormalStyle];
}

- (void)createViews {

    _videoTitle = [[UILabel alloc] init];
    _mentionInfo = [[UILabel alloc] init];

    _quitAirPlayBtn = [[UIButton alloc] init];
    _volumeLargeBtn = [[UIButton alloc] init];
    _volumeSmallBtn = [[UIButton alloc] init];
    _playPauseBtn = [[UIButton alloc] init];

    [self addSubview:_videoTitle];
    [self addSubview:_mentionInfo];
    [self addSubview:_quitAirPlayBtn];
    [self addSubview:_volumeLargeBtn];
    [self addSubview:_volumeSmallBtn];
    [self addSubview:_playPauseBtn];

    _videoTitle.textColor = [MCColor custom:@"player_terminal_titlecolor"];
    _videoTitle.font = [UIFont systemFontOfSize:14];

    _mentionInfo.textColor = [MCColor custom:@"player_terminal_mentioncolor"];
    _mentionInfo.font = [UIFont systemFontOfSize:12];

    _videoTitle.textAlignment = NSTextAlignmentCenter;
    _mentionInfo.textAlignment = NSTextAlignmentCenter;

    self.backgroundColor = [MCColor custom:@"player_terminal_bgcolor"];
}

- (void)addLayout {
    if (CGRectIsEmpty(self.frame)) return;
    UIEdgeInsets insets = [MCStyle customInsets:@"player_terminal_inset"];
    CGFloat h = CGRectGetHeight(self.frame);
    CGFloat w = CGRectGetWidth(self.frame);

    self.videoTitle.frame = CGRectMake(insets.left,
            (h - self.videoTitle.font.lineHeight) / 2.0f,
            w - 2 * insets.left,
            self.videoTitle.font.lineHeight);

    self.mentionInfo.frame = CGRectMake(insets.left,
            CGRectGetMaxY(self.videoTitle.frame) + insets.top,
            CGRectGetWidth(self.videoTitle.frame),
            self.mentionInfo.font.lineHeight);

//
//    [_quitAirPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mentionInfo.mas_bottom).offset(10);
//        make.centerX.mas_equalTo(self);
//        make.width.mas_equalTo(100);
//        make.height.mas_equalTo(30);
//    }];
//
//    [_volumeLargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.mas_right).offset(-30);
//        make.centerY.mas_equalTo(self.mas_centerY).offset(-40);
//        make.width.height.mas_equalTo(40);
//    }];
//
//    [_volumeSmallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.mas_right).offset(-30);
//        make.centerY.mas_equalTo(self.mas_centerY).offset(40);
//        make.width.height.mas_equalTo(40);
//    }];
//
//    [_playPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.mas_left).offset(30);
//        make.bottom.mas_equalTo(self.mas_bottom).offset(-30);
//        make.width.height.mas_equalTo(40);
//    }];
}

- (void)addAction {
    _quitAirPlayBtn.tag = PTAPQuitAirPlayEvent;
    _volumeLargeBtn.tag = PTAPAirPlayVolumeLarge;
    _volumeSmallBtn.tag = PTAPAirPlayVolumeSmall;
    _playPauseBtn.tag = PTAPAirPlayPause;

    [_quitAirPlayBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_volumeLargeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_volumeSmallBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_playPauseBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)updateStyle {
    [_quitAirPlayBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_quitAirPlayBtn setTitle:@"退出投屏播放" forState:UIControlStateNormal];
    [_quitAirPlayBtn setTitleColor:[UIColor colorWithRed:36 / 255.0 green:218 / 255.0 blue:161 / 255.0 alpha:1] forState:UIControlStateNormal];

    _quitAirPlayBtn.layer.cornerRadius = 10;
    _quitAirPlayBtn.layer.borderColor = [UIColor colorWithRed:36 / 255.0 green:218 / 255.0 blue:161 / 255.0 alpha:1].CGColor;
    _quitAirPlayBtn.layer.masksToBounds = YES;
    _quitAirPlayBtn.layer.borderWidth = 1;
    _quitAirPlayBtn.titleLabel.font = [UIFont systemFontOfSize:12];

    [_volumeLargeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_volumeSmallBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_playPauseBtn setImage:[UIImage imageNamed:@"ic_pause"] forState:UIControlStateNormal];
    [_playPauseBtn setImage:[UIImage imageNamed:@"ic_play"] forState:UIControlStateSelected];


}

- (void)showNormalStyle {
    _quitAirPlayBtn.hidden = YES;
    _volumeLargeBtn.hidden = YES;
    _volumeSmallBtn.hidden = YES;
    _playPauseBtn.hidden = YES;
}

- (void)showAirpalyStyle {
    _quitAirPlayBtn.hidden = NO;
    _volumeLargeBtn.hidden = NO;
    _volumeSmallBtn.hidden = NO;
    _playPauseBtn.hidden = NO;
}

- (void)updatePlayerTerminal:(MCPlayerTerminalState)state title:(NSString *)videoTitle {

    _videoTitle.text = videoTitle;
    [self showNormalStyle];
    switch (state) {
        case MCPlayerTerminalPlayEnd    : {
            _mentionInfo.text = _kMC_AV_TerminalMentionPlayerStatePlayEnd;
            [self tapGestureRecognizer];
        }
            break;

        case MCPlayerTerminal3GUnenable : {
            _mentionInfo.text = _kMC_AV_TerminalMentionPlayerState3GUnenable;
            _mentionInfo.textColor = [MCColor custom:@"player_terminal_mentioncolor_alert"];
            [self tapGestureRecognizer];
        }
            break;

        case MCPlayerTerminalNetError   : {
            _mentionInfo.text = _kMC_AV_TerminalMentionPlayerStateNetError;
            _mentionInfo.textColor = [MCColor custom:@"player_terminal_mentioncolor_alert"];
            [self tapGestureRecognizer];
        }
            break;

        case MCPlayerTerminalUrlError   : {
            _mentionInfo.text = _kMC_AV_TerminalMentionPlayerStateUrlError;
            _mentionInfo.textColor = [MCColor custom:@"player_terminal_mentioncolor_alert"];
            [self tapGestureRecognizer];
        }
            break;

        case MCPlayerTerminalError      : {
            _mentionInfo.text = _kMC_AV_TerminalMentionPlayerStateError;
            _mentionInfo.textColor = [MCColor custom:@"player_terminal_mentioncolor_alert"];
            [self tapGestureRecognizer];
        }
            break;

        default: {

        }
            break;
    }
    _playerSate = state;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addLayout];
}


#pragma mark -
#pragma mark private

- (UITapGestureRecognizer *)tapGestureRecognizer {
    if (_tapGestureRecognizer == nil) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:_tapGestureRecognizer];
    }
    return _tapGestureRecognizer;
}

- (void)removeTapGesture {
    if (_tapGestureRecognizer) {
        [self removeGestureRecognizer:_tapGestureRecognizer];
        [_tapGestureRecognizer removeTarget:self action:@selector(tapClick:)];
        _tapGestureRecognizer = nil;
    }
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    if (_delegate == nil) return;
    switch (_playerSate) {
        case MCPlayerTerminalPlayEnd     : {
            if ([_delegate respondsToSelector:@selector(terminalPlayEndReplay)]) {
                [_delegate terminalPlayEndReplay];
            }
        }
            break;

        case MCPlayerTerminal3GUnenable : {
            if ([_delegate respondsToSelector:@selector(terminal3GCanContinuePlay)]) {

                [_delegate terminal3GCanContinuePlay];
            }
        }
            break;

        case MCPlayerTerminalNetError   : {
            if ([_delegate respondsToSelector:@selector(terminalNetErrorRetry)]) {
                [_delegate terminalNetErrorRetry];
            }
        }
            break;

        case MCPlayerTerminalUrlError   : {
            if ([_delegate respondsToSelector:@selector(terminalUrlErrorRetry)]) {
                [_delegate terminalUrlErrorRetry];
            }
        }
            break;

        case MCPlayerTerminalError      : {
            if ([_delegate respondsToSelector:@selector(terminalErrorRetry)]) {
                [_delegate terminalErrorRetry];
            }
        }
            break;
        default:
            break;
    }
}

- (void)btnClick:(UIButton *)btn {
    switch (btn.tag) {
        case PTAPQuitAirPlayEvent : {
            if ([_delegate respondsToSelector:@selector(terminalQuitAirplay2Play)]) {
                [_delegate terminalQuitAirplay2Play];
            }
            self.hidden = YES;
        }
            break;
        case PTAPAirPlayPlay : {
            btn.selected = !btn.selected;
            btn.tag = PTAPAirPlayPause;
            if ([_delegate respondsToSelector:@selector(terminalAirplayPlay)]) {
                [_delegate terminalAirplayPlay];
            }
        }
            break;
        case PTAPAirPlayPause : {
            btn.selected = !btn.selected;
            btn.tag = PTAPAirPlayPlay;
            if ([_delegate respondsToSelector:@selector(terminalAirplayPause)]) {
                [_delegate terminalAirplayPause];
            }
        }
            break;
        case PTAPAirPlayVolumeLarge : {
            if ([_delegate respondsToSelector:@selector(terminalAirplayVolumeLarge)]) {
                [_delegate terminalAirplayVolumeLarge];
            }
        }
            break;
        case PTAPAirPlayVolumeSmall : {
            if ([_delegate respondsToSelector:@selector(terminalAirplayVolumeSmall)]) {
                [_delegate terminalAirplayVolumeSmall];
            }
        }
            break;
    }
}

@end

//
// Created by littleplayer on 16/5/20.
// Copyright (c) 2016 mjc inc. All rights reserved.
//

#import "MCPlayerGeneralTerminalView.h"

#import <Masonry.h>
#import <MCStyle/MCStyleDef.h>

#import "MCPlayerViewConfig.h"


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
@property(nonatomic, assign) PlayerState playerSate;

@property(nonatomic, strong) UIButton *quitAirPlayBtn;
@property(nonatomic, strong) UIButton *volumeLargeBtn;
@property(nonatomic, strong) UIButton *volumeSmallBtn;
@property(nonatomic, strong) UIButton *playPauseBtn;

@end

@implementation MCPlayerGeneralTerminalView

- (void)dealloc {
    [self releaseSpace];
}

- (void)releaseSpace {
    [_videoTitle removeFromSuperview];
    [_mentionInfo removeFromSuperview];
    [self removeTapGesture];

    [_quitAirPlayBtn removeFromSuperview];
    [_volumeLargeBtn removeFromSuperview];
    [_volumeSmallBtn removeFromSuperview];
    [_playPauseBtn removeFromSuperview];

    _videoTitle = nil;
    _mentionInfo = nil;

    _quitAirPlayBtn = nil;
    _volumeLargeBtn = nil;
    _volumeSmallBtn = nil;
    _playPauseBtn = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

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

        _videoTitle.textColor = [MCColor colorI];
        _videoTitle.font = [UIFont systemFontOfSize:14];

        _mentionInfo.textColor = [MCColor colorII];
        _mentionInfo.font = [UIFont systemFontOfSize:12];

        _videoTitle.textAlignment = NSTextAlignmentCenter;
        _mentionInfo.textAlignment = NSTextAlignmentCenter;

        self.backgroundColor = [MCColor colorV];

        [self addAction];
        [self updateStyle];
        [self showNormalStyle];
    }
    return self;
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

- (void)updatePlayerTerminal:(PlayerState)state title:(NSString *)videoTitle {

    _videoTitle.text = videoTitle;
    [self showNormalStyle];
//    switch(state) {
//        case PlayerStatePlayEnd    : {
//            _mentionInfo.text   = _k_AV_TerminalMentionPLayerStatePlayEnd;
//            [self tapGestureRecognizer];
//        } break;
//
//        case PlayerState3GUnenable : {
//            _mentionInfo.text = _k_AV_TerminalMentionPlayerState3GUnenable;
////            _mentionInfo.textColor = [UIColor greenColor];
//            [self tapGestureRecognizer];
//        } break;
//
//        case PlayerStateNetError   : {
//            _mentionInfo.text = _k_AV_TerminalMentionPlayerStateNetError;
////            _mentionInfo.textColor = [UIColor redColor];
//            [self tapGestureRecognizer];
//        } break;
//
//        case PlayerStateUrlError   : {
//            _mentionInfo.text = _k_AV_TerminalMentionPlayerStateUrlError;
////            _mentionInfo.textColor = [UIColor whiteColor];
//            [self tapGestureRecognizer];
//        } break;
//
//        case PlayerStateError      : {
//            _mentionInfo.text = _k_AV_TerminalMentionPlayerStateError;
////            _mentionInfo.textColor = [UIColor whiteColor];
//            [self tapGestureRecognizer];
//        } break;
//
//        default                      : {
//
//        } break;
//    }
    _playerSate = state;
}

- (void)updateConstraints {
    [_videoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(0);
    }];

    [_mentionInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(20);
    }];

    [_quitAirPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mentionInfo.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];

    [_volumeLargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-30);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-40);
        make.width.height.mas_equalTo(40);
    }];

    [_volumeSmallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-30);
        make.centerY.mas_equalTo(self.mas_centerY).offset(40);
        make.width.height.mas_equalTo(40);
    }];

    [_playPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(30);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-30);
        make.width.height.mas_equalTo(40);
    }];

    [super updateConstraints];
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
//    switch(_playerSate) {
//        case PlayerStatePlayEnd     : {
//            [_delegate terninalPlayEndReplay];
//        } break;
//
//        case  PlayerState3GUnenable : {
//            [_delegate terminal3GCanContinuePlay];
//        } break;
//
//        case  PlayerStateNetError   : {
//            [_delegate terminalNetErrorRetry];
//        } break;
//
//        case  PlayerStateUrlError   : {
//            [_delegate terminalUrlErrorRetry];
//        } break;
//
//        case  PlayerStateError      : {
//            [_delegate terminalErrorRetry];
//        } break;
//        default:break;
//    }
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

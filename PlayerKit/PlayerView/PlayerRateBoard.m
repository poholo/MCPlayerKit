//
// Created by majiancheng on 2017/3/27.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "PlayerRateBoard.h"

#import <ReactiveCocoa.h>
#import <Masonry.h>

#import "WQColorStyle.h"
#import "ViewShapeMask.h"
#import "VideoLocal.h"
#import "Entity+GlobalDao.h"
#import "VideoLocal+Dao.h"
#import "AppSetting.h"
#import "FeedbackDetailsViewModel.h"
#import "UIColor+Hex.h"
#import "UIScreen+Extend.h"

@interface PlayerRateBoard ()

@property(nonatomic, strong) FeedbackDetailsViewModel *viewModel;
@property(nonatomic, assign) PlayerStyle playerStyle;
@property(nonatomic, assign) BOOL canLoop;

@end

@implementation PlayerRateBoard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewModel = [[FeedbackDetailsViewModel alloc] init];
        _backView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = .8;
            [self addSubview:view];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
            [view addGestureRecognizer:tap];
            view;
        });

        _latePlayBtn = ({
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitle:@"稍后看" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"later"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.imageEdgeInsets = UIEdgeInsetsMake(-25, 10, 10, 0);
            btn.titleEdgeInsets = UIEdgeInsetsMake(25, -32, 0, 0);
            [btn addTarget:self action:@selector(laterPlay) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            btn.hidden = YES;
            btn;
        });

        _portraitBtn = ({
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitle:@"反馈" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"feedback_full"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.imageEdgeInsets = UIEdgeInsetsMake(-25, 10, 10, 0);
            btn.titleEdgeInsets = UIEdgeInsetsMake(25, -32, 0, 0);
            [btn addTarget:self action:@selector(feedbackBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            btn.hidden = YES;
            btn;
        });

        _airplayBtn = ({
            UIButton *btn = [[UIButton alloc] init];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setImage:[UIImage imageNamed:@"player_tv_big"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(airplayBtnClick) forControlEvents:UIControlEventTouchUpInside];
            btn.imageEdgeInsets = UIEdgeInsetsMake(-15, 10, 10, 0);
            btn.titleEdgeInsets = UIEdgeInsetsMake(35, -36, 0, -4);
            [btn setTitle:@"投电视" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self addSubview:btn];
            if (![AppSetting isDownloadable]) {
                btn.hidden = YES;
            }
            btn;
        });

        _circleBtn = ({
            UIButton *btn = [[UIButton alloc] init];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setImage:[UIImage imageNamed:@"order_full"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"repeatonce_full"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(circleBtnClick) forControlEvents:UIControlEventTouchUpInside];
            btn.imageEdgeInsets = UIEdgeInsetsMake(-15, 10, 10, 0);
            btn.titleEdgeInsets = UIEdgeInsetsMake(35, -36, 0, -4);
            [btn setTitle:@"循环" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self addSubview:btn];
            btn.hidden = YES;
            btn;
        });

        if (![AppSetting isDownloadable]) {
            _airplayBtn.hidden = YES;
        }

        _reportBtn = ({
            UIButton *btn = [[UIButton alloc] init];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setImage:[UIImage imageNamed:@"alert_big"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(actionReport) forControlEvents:UIControlEventTouchUpInside];
            btn.imageEdgeInsets = _airplayBtn.imageEdgeInsets;
            btn.titleEdgeInsets = _airplayBtn.titleEdgeInsets;
            [btn setTitle:@"举报" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self addSubview:btn];
            if (![AppSetting isDownloadable]) {
                btn.hidden = YES;
            }
            btn;
        });

        _feedBackBtn = ({
            UIButton *btn = [[UIButton alloc] init];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setImage:[UIImage imageNamed:@"feedback_full"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(feedbackBtnClick) forControlEvents:UIControlEventTouchUpInside];
            btn.imageEdgeInsets = UIEdgeInsetsMake(-15, 10, 10, 0);
            btn.titleEdgeInsets = UIEdgeInsetsMake(35, -36, 0, -4);
            [btn setTitle:@"反馈" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self addSubview:btn];
            if (![AppSetting isDownloadable]) {
                btn.hidden = YES;
            }
            btn;
        });

        _rateBgView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            [self addSubview:view];
            view;
        });

        _titleLbel = ({
            UILabel *label = [[UILabel alloc] init];
            label.text = @"播放速度";
            label.textColor = [UIColor colorWithHex:0xb2b2b2];
            label.font = [UIFont systemFontOfSize:14];
            [_rateBgView addSubview:label];
            label;
        });

        _xdot5Btn = ({
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = 1;
            [btn setTitle:@"0.5X" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [ViewShapeMask cornerView:btn radius:13 border:0 color:[UIColor whiteColor]];
            [_rateBgView addSubview:btn];
            btn;
        });
        _x1rateBtn = ({
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = 2;
            [btn setTitle:@"1.0X" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [ViewShapeMask cornerView:btn radius:13 border:0 color:[UIColor whiteColor]];
            [_rateBgView addSubview:btn];
            btn;
        });
        _x1dot5Btn = ({
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = 3;
            [btn setTitle:@"1.5X" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [ViewShapeMask cornerView:btn radius:13 border:0 color:[UIColor whiteColor]];
            [_rateBgView addSubview:btn];
            btn;
        });
        _x2dotBtn = ({
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = 4;
            [btn setTitle:@"2.0X" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [ViewShapeMask cornerView:btn radius:13 border:0 color:[UIColor whiteColor]];
            [_rateBgView addSubview:btn];
            btn;
        });
        self.playerStyle = PlayerStyleSizeClassRegularHalf;
    }
    return self;
}

- (void)setPlayerStyle:(PlayerStyle)playerStyle {
    _playerStyle = playerStyle;
    if (_playerStyle == PlayerStyleSizeClassCompact) {
        _latePlayBtn.hidden = YES;
        _reportBtn.hidden = NO;
        _airplayBtn.hidden = NO;
        _circleBtn.hidden = !self.canLoop;
        _feedBackBtn.hidden = NO;
        _portraitBtn.hidden = YES;
    } else {
        _latePlayBtn.hidden = NO;
        _reportBtn.hidden = YES;
        _airplayBtn.hidden = YES;
        _circleBtn.hidden = YES;
        _feedBackBtn.hidden = YES;
        _portraitBtn.hidden = NO;
    }
    if (![AppSetting isDownloadable]) {
        _airplayBtn.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

- (void)canShowCircle:(BOOL)circle {
    self.canLoop = circle;
    if (self.playerStyle == PlayerStyleSizeClassCompact) {
        _circleBtn.hidden = !circle;
    } else {
        _circleBtn.hidden = YES;
    }
}

- (void)circle:(BOOL)isCircle {
    _circleBtn.selected = isCircle;
}


- (void)updateConstraints {
    @weakify(self);
    [_backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self);
    }];


    CGFloat topOffset = 50;
    CGFloat bottomOffset = 50;
    CGFloat xoffset0 = 22.5;
    CGFloat xOffset1 = 50;
    CGFloat xOffset2 = 24;
    CGFloat width = 64;
    CGFloat rateWidth = 378;

    float rwidth = 54;
    float rheight = 26;


    switch (_playerStyle) {
        case PlayerStyleSizeClassRegularHalf: {
            topOffset = 10;
            bottomOffset = 80;
            xoffset0 = 10;
            xOffset1 = 24;
            xOffset2 = 5;
            width = 55;
            rateWidth = 300;
            rwidth = 54;
            rheight = 26;
        }
            break;
        case PlayerStyleSizeClassRegular: {
            topOffset = 10;
            bottomOffset = 80;
            xoffset0 = 10;
            xOffset1 = 24;
            xOffset2 = 5;
            width = 55;
            rateWidth = 378;
            rwidth = 54;
            rheight = 26;
        }
            break;
        case PlayerStyleSizeClassCompact: {
            topOffset = 50;
            bottomOffset = 50;
            xoffset0 = 22.5;
            xOffset1 = 24;
            xOffset2 = 20;
            width = 55;
            rateWidth = MAX([UIScreen width], [UIScreen height]) - 200;
            rwidth = 70;
            rheight = 26;
        }
            break;
    }

    [_latePlayBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self).offset(-topOffset);
        make.centerX.equalTo(self).offset(-width / 2);
        make.width.height.mas_equalTo(width);
    }];

    [_portraitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self).offset(-topOffset);
        make.centerX.equalTo(self).offset(width / 2);
        make.width.height.mas_equalTo(width);
    }];

    [_airplayBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (_circleBtn.hidden) {
            make.centerX.equalTo(self->_reportBtn.mas_left).offset(-width);
        } else {
            make.centerX.equalTo(self->_circleBtn.mas_left).offset(-width);
        }
        make.centerY.equalTo(self).offset(-topOffset);
        make.size.mas_equalTo(CGSizeMake(width, width));
    }];

    [_circleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(-width / 2);
        make.centerY.equalTo(_airplayBtn);
        make.size.mas_equalTo(CGSizeMake(width, width));
    }];

    [_reportBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (_circleBtn.hidden) {
            make.left.equalTo(self.mas_centerX).offset(-width / 2);
        } else if (![AppSetting isDownloadable] && _circleBtn.hidden) {
            make.left.equalTo(self.mas_centerX).offset(-1.5 * width);
        } else {
            make.left.equalTo(_circleBtn.mas_right).offset(width / 2);
        }
        make.left.equalTo(_circleBtn.mas_right).offset(width / 2);
        make.centerY.equalTo(_airplayBtn);
        make.size.mas_equalTo(CGSizeMake(width, width));
    }];

    [_feedBackBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_reportBtn.mas_right).offset(width / 2);
        make.centerY.equalTo(_airplayBtn);
        make.size.mas_equalTo(CGSizeMake(width, width));
    }];

    [_rateBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.mas_centerY).offset(topOffset);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(rateWidth, 50));
    }];

    [_titleLbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rateBgView).offset(0);
        make.bottom.equalTo(_rateBgView).offset(0);
    }];


    [_xdot5Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLbel.mas_right).offset(xoffset0);
        make.centerY.equalTo(_titleLbel);
        make.width.mas_equalTo(rwidth);
        make.height.mas_equalTo(rheight);
    }];

    [_x1rateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_xdot5Btn.mas_right).offset(xOffset2);
        make.centerY.equalTo(_titleLbel);
        make.width.mas_equalTo(rwidth);
        make.height.mas_equalTo(rheight);

    }];

    [_x1dot5Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLbel);
        make.left.equalTo(_x1rateBtn.mas_right).offset(xOffset2);
        make.width.mas_equalTo(rwidth);
        make.height.mas_equalTo(rheight);

    }];

    [_x2dotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLbel);
        make.left.equalTo(_x1dot5Btn.mas_right).offset(xOffset2);
        make.width.mas_equalTo(rwidth);
        make.height.mas_equalTo(rheight);

    }];

    [super updateConstraints];
}

- (void)selectRate:(CGFloat)rate {
    NSInteger rateX = rate * 10;
    _befSelectBtn.layer.borderWidth = 0;
    if (rateX == 5) {
        _befSelectBtn = _xdot5Btn;
        _xdot5Btn.layer.borderWidth = 1;
    } else if (rateX == 10) {
        _befSelectBtn = _x1rateBtn;
        _x1rateBtn.layer.borderWidth = 1;
    } else if (rateX == 15) {
        _befSelectBtn = _x1dot5Btn;
        _x1dot5Btn.layer.borderWidth = 1;
    } else if (rateX == 20) {
        _befSelectBtn = _x2dotBtn;
        _x2dotBtn.layer.borderWidth = 1;
    }
}

- (void)btnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(changeRate:)]) {
        [self.delegate changeRate:btn.tag * 0.5];
        [self selectRate:btn.tag * 0.5f];
        [self tapClick];
    }
}

- (void)laterPlay {
    if ([self.delegate respondsToSelector:@selector(laterPlay)]) {
        [self.delegate laterPlay];
        [self tapClick];
    }
}

- (void)actionReport {
    if ([self.delegate respondsToSelector:@selector(actionFeedBack)]) {
        [self.delegate actionFeedBack];
        [self tapClick];
    }
}

- (void)airplayBtnClick {
    if ([self.delegate respondsToSelector:@selector(showAirplay)]) {
        [self.delegate showAirplay];
    }
    self.hidden = YES;
}

- (void)tapClick {
    self.hidden = YES;
}

- (void)circleBtnClick {
    _circleBtn.selected = !_circleBtn.selected;
    if ([self.delegate respondsToSelector:@selector(changeCircle:)]) {
        [self.delegate changeCircle:_circleBtn.selected];
        [self tapClick];
    }
}

- (void)feedbackBtnClick {
    if ([self.delegate respondsToSelector:@selector(feedBack)]) {
        [self.delegate feedBack];
        [self tapClick];
    }
}


@end

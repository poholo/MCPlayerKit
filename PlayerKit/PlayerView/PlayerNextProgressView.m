//
//  PlayerNextProgressView.m
//  WaQuVideo
//
//  Created by gdb-work on 17/4/18.
//  Copyright © 2017年 mjc inc. All rights reserved.
//

#import "PlayerNextProgressView.h"

#import <ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <WaQuBase/NSURL+Convert2HTTPS.h>

#import "GCD.h"
#import "CoinCircleProgressView.h"
#import "WaQuUI.h"
#import "WQColorStyle.h"
#import "Utilities.h"
#import "UIScreen+Extend.h"
#import "MMDto.h"
#import "MMCollectionView.h"
#import "UIColor+Hex.h"
#import "PlayerQudanCardCollectionViewCell.h"
#import "MMVideoDto.h"
#import "HWWeakTimer.h"
#import "Video.h"

#define RECOVER_TIME 7.0f

@interface PlayerNextProgressView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) CGFloat progress;
@property(nonatomic, strong) CoinCircleProgressView *circleView;
@property(nonatomic, strong) MMButton *backBtn;
@property(nonatomic, strong) MMButton *stopBtn;
@property(nonatomic, strong) MMButton *replayBtn;
@property(nonatomic, strong) MMLabel *timeLab;
@property(nonatomic, strong) MMLabel *titleLab;
@property(nonatomic, strong) MMImageView *bgView;
@property(nonatomic, strong) MMView *coverView;

@property(nonatomic, assign) PlayerStyle playerStyle;
@property(nonatomic, strong) UILabel *relatedTitle;
@property(nonatomic, strong) MMCollectionView *collectionView;
@property(nonatomic, strong) NSArray<MMDto *> *dtos;

@property(nonatomic, strong) UIButton *cancelBtn;
@property(nonatomic, strong) UIButton *playNowBtn;
@property(nonatomic, strong) UIButton *playNextBtn;

@end

@implementation PlayerNextProgressView

- (void)dealloc {
    [self stopTimer];
    self.progressEndBlock = nil;
    self.replayBlock = nil;
    self.backBlock = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPlayerStyle:(PlayerStyle)playerStyle {
    _playerStyle = playerStyle;
    switch (playerStyle) {
        case PlayerStyleSizeClassRegularHalf: {
            self.collectionView.hidden = YES;
            self.relatedTitle.hidden = YES;
        }
            break;
        case PlayerStyleSizeClassRegular: {
            self.collectionView.hidden = NO;

            if (self.dtos.count > 0) {
                self.relatedTitle.hidden = NO;
            } else {
                self.relatedTitle.hidden = YES;
            }
        }
            break;
        case PlayerStyleSizeClassCompact: {
            self.collectionView.hidden = NO;
            self.relatedTitle.hidden = NO;

            if (self.dtos.count > 0) {
                self.relatedTitle.hidden = NO;
            } else {
                self.relatedTitle.hidden = YES;
            }
        }
            break;
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

- (void)updateRalated:(NSArray<MMDto *> *)dtos {
    self.dtos = dtos;
    [self.collectionView reloadData];
}

- (instancetype)initWithDuration:(NSNumber *)duration title:(NSString *)title videoPic:(NSString *)videoPic {
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [WQColorStyle maskBlackColor];

        self.bgView = [[MMImageView alloc] init];
        [self.bgView setImageURL:videoPic defaultImage:nil];
        [self addSubview:self.bgView];

        self.coverView = [[MMView alloc] init];
        self.coverView.backgroundColor = [WQColorStyle maskLayerColor];
        self.coverView.userInteractionEnabled = NO;
        [self addSubview:self.coverView];

        self.backBtn = [[MMButton alloc] init];
        self.backBtn.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        [self.backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];;
        [self.backBtn addTarget:self action:@selector(actionTapBack) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backBtn];

        self.titleLab = [[MMLabel alloc] init];
        self.titleLab.font = [UIFont systemFontOfSize:15];
        self.titleLab.numberOfLines = 1;
        self.titleLab.textColor = [WQColorStyle subTextColor];
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.titleLab];

        NSString *titleStr = [NSString stringWithFormat:@"接下来播放 %@", title ? title : @""];
        NSMutableAttributedString *titleAttStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
        [titleAttStr setAttributes:@{NSForegroundColorAttributeName: [WQColorStyle whiteColor]} range:NSMakeRange(titleStr.length - title.length, title.length)];
        self.titleLab.attributedText = titleAttStr;

        self.stopBtn = [[MMButton alloc] init];
        self.stopBtn.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        [self.stopBtn setImage:[UIImage imageNamed:@"play_next"] forState:UIControlStateNormal];;
        [self.stopBtn addTarget:self action:@selector(actionTapStop) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.stopBtn];

        self.replayBtn = [[MMButton alloc] init];
        self.replayBtn.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        [self.replayBtn setBackgroundImage:[UIImage imageNamed:@"play_reverse_big"] forState:UIControlStateNormal];;
        [self.replayBtn addTarget:self action:@selector(actionTapReplay) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.replayBtn];

        self.circleView = [[CoinCircleProgressView alloc] initWithFrame:CGRectMake(0, 0, PROGRESS_WIDTH, PROGRESS_WIDTH)];
        self.circleView.progressColor = [UIColor whiteColor];//RGBCOLOR(105, 188, 252);
        [self.stopBtn addSubview:self.circleView];

        self.timeLab = [[MMLabel alloc] init];
        self.timeLab.font = [UIFont systemFontOfSize:14];
        self.timeLab.text = [Utilities millisecondToHumanString:duration.floatValue * 1000];
        self.timeLab.textColor = [WQColorStyle whiteColor];
        self.timeLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.timeLab];

        self.cancelBtn = ({
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            btn;
        });

        self.playNowBtn = ({
            UIButton *btn = [[UIButton alloc] init];
            [btn setBackgroundImage:[UIImage imageNamed:@"reverse_big"] forState:UIControlStateNormal];;
            [btn addTarget:self action:@selector(actionTapReplay) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            btn.hidden = YES;
            btn;
        });

        self.playNextBtn = ({
            UIButton *btn = [[UIButton alloc] init];
            [btn setBackgroundImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];;
            [btn addTarget:self action:@selector(playNext) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            btn.hidden = YES;
            btn;
        });

        self.relatedTitle = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor colorWithHex:0xa6a5ac];
            label.font = [UIFont systemFontOfSize:12];
            label.text = @"相关推荐";
            [self addSubview:label];
            @weakify(self);
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.width.mas_equalTo(100 * 3 + 2 * 16);
                make.centerX.equalTo(self.mas_centerX);
                make.centerY.equalTo(self.mas_centerY).offset(30);
                make.height.mas_equalTo(20);
            }];
            label;
        });

        self.collectionView = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.itemSize = CGSizeMake(100, 100);
            layout.minimumInteritemSpacing = 16;


            MMCollectionView *collectionView1 = [[MMCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];

            [self addSubview:collectionView1];
            collectionView1.dataSource = self;
            collectionView1.delegate = self;
            collectionView1.backgroundColor = [UIColor clearColor];

            @weakify(self);
            [collectionView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.width.mas_equalTo(100 * 3 + 2 * 16);
                make.height.mas_equalTo(100);
                make.centerX.equalTo(self);
                make.top.equalTo(self.relatedTitle.mas_bottom).offset(10);
            }];


            [collectionView1 registerClass:[PlayerQudanImageCardCollectionViewCell class] forCellWithReuseIdentifier:[PlayerQudanImageCardCollectionViewCell identifier]];

            collectionView1.showsHorizontalScrollIndicator = NO;
            collectionView1.bounces = YES;
            collectionView1;
        });

        [self layoutIfNeeded];

        [self startProgress];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopNextProgress:) name:@"stopNextProgress" object:nil];
    }

    return self;
}

- (void)updateConstraints {
    @weakify(self);
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(6);
        make.top.equalTo(self).offset(21);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];

    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn.mas_right).offset(2);
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self.backBtn);
        make.height.equalTo(@(44));
    }];

    [self.stopBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        if (self.playerStyle == PlayerStyleSizeClassRegularHalf) {
            make.centerY.equalTo(self);
        } else {
            make.centerY.equalTo(self).offset(-40);
        }
        make.size.mas_equalTo(CGSizeMake(PROGRESS_WIDTH, PROGRESS_WIDTH));
    }];

    [self.circleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.stopBtn);
    }];

    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.stopBtn);
        make.top.equalTo(self.stopBtn.mas_bottom).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];

    [self.timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self).offset(-20);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];

    [self.replayBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stopBtn.mas_right).offset(30);
        make.centerY.equalTo(self.stopBtn);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];

    [self.playNowBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.centerY.width.height.equalTo(self.stopBtn);
    }];

    [self.playNextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.centerY.equalTo(self.replayBtn);
        make.width.height.mas_equalTo(25);
    }];

    [self.coverView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [super updateConstraints];
}

- (void)startProgress {
    if (self.timer == nil) {
        @weakify(self);
        self.timer = [HWWeakTimer scheduledTimerWithTimeInterval:1 / 30.0f block:^(id userInfo) {
            @strongify(self);
            [[GCDQueue mainQueue] execute:^{
                @strongify(self);
                [self recoverCombo];
            }];
        }                                               userInfo:nil repeats:YES];
    }
}

- (void)recoverCombo {
    self.progress += 1 / (RECOVER_TIME * 30.0f);

    self.circleView.progress = self.progress;

    if (self.progress >= 1) {
        [self actionTapStop];
    }
}

- (void)stopTimer {
    self.hidden = YES;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self removeFromSuperview];
}

- (void)actionTapStop {
    [self stopTimer];
    if (self.progressEndBlock) {
        self.progressEndBlock();
    }
}

- (void)actionTapBack {
    if(self.playerStyle == PlayerStyleSizeClassRegularHalf) {
        [self stopTimer];
    }
    if (self.backBlock) {
        self.backBlock();
    }
}

- (void)actionTapReplay {
    [self stopTimer];
    if (self.replayBlock) {
        self.replayBlock();
    }
}

- (void)playNext {
    [self stopTimer];
    if ([self.delegate respondsToSelector:@selector(playerNextProgressPlayNext)]) {
        [self.delegate playerNextProgressPlayNext];
    }
}

- (void)didEnterBackground:(NSNotification *)notification {
    if (self.timer) {
        if (![self.timer isValid]) return;
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)willEnterForground:(NSNotification *)notification {
    if (self.timer) {
        if (![self.timer isValid]) return;
        [self.timer setFireDate:[NSDate date]];
    }
}

- (void)willResignActive:(NSNotification *)notification {
    if (self.timer) {
        if (![self.timer isValid]) return;
        [self.timer setFireDate:[NSDate date]];
    }
}

- (void)stopNextProgress:(NSNotification *)notification {
    [self stopTimer];
}

- (void)btnCancelClick {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.playNextBtn.hidden = NO;
    self.playNowBtn.hidden = NO;

    self.circleView.hidden = YES;
    self.stopBtn.hidden = YES;
    self.replayBtn.hidden = YES;

    self.cancelBtn.hidden = YES;
    self.titleLab.hidden = YES;
    [_bgView sd_setImageWithURL:[NSURL convert2HTTPSURLWithString:_currentVideo.imgUrl] placeholderImage:[UIImage imageNamed:@"topic_default"]];

}

#pragma mark - UICollectionViewDataSource Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlayerQudanImageCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PlayerQudanImageCardCollectionViewCell identifier] forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    [cell select:self.dtos[(NSUInteger) indexPath.row] isSelected:NO];
    [cell hiddleSubtitle:YES];
    MMVideoDto *mmdto = (MMVideoDto *) self.dtos[(NSUInteger) indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dtos.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(playerNextProgressViewRelatedPlayVideo:)]) {
        [self.delegate playerNextProgressViewRelatedPlayVideo:self.dtos[(NSUInteger) indexPath.row]];
    }
}

@end

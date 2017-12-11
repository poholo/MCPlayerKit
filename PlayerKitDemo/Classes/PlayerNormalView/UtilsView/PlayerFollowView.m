//
// Created by majiancheng on 2017/5/17.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "PlayerFollowView.h"


#import <Masonry.h>
#import <ReactiveCocoa.h>

#import "FollowButton.h"
#import "Video.h"
#import "UtilsMacro.h"
#import "Playlist.h"
#import "Topic.h"
#import "LiveUserDto.h"

@interface PlayerFollowView ()

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subTitleLabel;
@property(nonatomic, strong) FollowButton *followButton;
@property(nonatomic, assign) FollowType followType;

@property(nonatomic, strong) RACDisposable *showDispose;
@property(nonatomic, strong) RACDisposable *dismissDispose;

@end

@implementation PlayerFollowView

- (void)dealloc {
    [self releaseSpace];
}

- (void)releaseSpace {
    [self releaseShowDispose];
    [self releaseDismissDispose];
    [self.dismissDispose dispose];
    [_titleLabel removeFromSuperview];
    [_subTitleLabel removeFromSuperview];
    [_followButton removeFromSuperview];

    _titleLabel = nil;
    _subTitleLabel = nil;
    _followButton = nil;
}

- (void)releaseShowDispose {
    if (self.showDispose) {
        [self.showDispose dispose];
        self.showDispose = nil;
    }
}

- (void)releaseDismissDispose {
    if (self.dismissDispose) {
        [self.dismissDispose dispose];
        self.dismissDispose = nil;
    }
}

- (instancetype)init {
    if (self = [super init]) {
        [self createView];
        [self updateStyle];
        [self addAction];
    }
    return self;
}

- (void)createView {
    _titleLabel = [[UILabel alloc] init];
    _subTitleLabel = [[UILabel alloc] init];
    _followButton = [[FollowButton alloc] init];

    [self addSubview:_titleLabel];
    [self addSubview:_subTitleLabel];
    [self addSubview:_followButton];
}

- (void)updateStyle {
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:14.0f];

    _subTitleLabel.textColor = WQ_SUBTITLE_COLOR;
    _subTitleLabel.font = WQ_WANGXINSubTITLE_SIZE;

    self.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.6f];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, 0.0f, 400.0f, 40.0f)
                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft
                                                         cornerRadii:CGSizeMake(20.0f, 20.0f)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0.0f, 0.0f, 400.0f, 40.0f);
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;

}

- (void)addAction {
    [self.followButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateConstraints {
    [_followButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
        make.height.offset(26.0f);
        make.width.offset(56.0f);
    }];

    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(6);
        make.right.mas_equalTo(self.followButton.mas_left).offset(5);
        make.height.offset(15.0f);
        make.left.offset(15.0f);
    }];

    [_subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.bottom.equalTo(self.mas_bottom).offset(-6);
        make.top.equalTo(_titleLabel.mas_bottom).offset(4.0f);
        make.width.equalTo(_titleLabel.mas_width);
    }];

    [super updateConstraints];
}

- (void)updateData:(id)data {
    if ([data isKindOfClass:[Playlist class]]) {
        _titleLabel.text = ((Playlist *) data).name;
        _subTitleLabel.text = [NSString stringWithFormat:@"%zd个人关注", ((Playlist *) data).favCount.integerValue];
        self.followType = FollowPlayList;
    } else if ([data isKindOfClass:[LiveUserDto class]]) {
        LiveUserDto *user = data;
        _titleLabel.text = user.nickName;
        _subTitleLabel.text = [NSString stringWithFormat:@"%zd个关注", user.focusCount.integerValue];
        self.followType = FollowAnchor;
    } else if ([data isKindOfClass:[Topic class]]) {
        Topic *topic = data;
        _titleLabel.text = topic.name;
        _subTitleLabel.text = [NSString stringWithFormat:@"%zd个关注", topic.likeCount];
        self.followType = FollowTopic;
    }

}

- (void)btnClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(updateLikeSection0VideoCard:followType:)]) {
        [_delegate updateLikeSection0VideoCard:self.followButton followType:self.followType];
    }
}


- (void)showFollowPlayerViewAnimaiton:(BOOL)animation {
    id data = nil;
    if ([self.delegate respondsToSelector:@selector(requestFolllowData)]) {
        data = [self.delegate requestFolllowData];
        [self updateData:data];
    }

    if (data == nil)
        return;

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenFollowPlayerViewAnimation:) object:nil];
    self.followButton.selected = NO;
    CGFloat width = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}].width + 56 + 10 + 20;
    width = width > 200 ? width : 200;
    width = width > 400 ? 400 : width;
    self.hidden = NO;
    @weakify(self);
    [self releaseShowDispose];
    self.showDispose = [[RACScheduler mainThreadScheduler] afterDelay:.0 schedule:^{
        [UIView animateWithDuration:.3 animations:^{
            @strongify(self);
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.width.mas_equalTo(width);
                make.right.mas_equalTo(self.superview.mas_right).offset(0);
            }];
            [self layoutIfNeeded];
        }                completion:^(BOOL finished) {
            @strongify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                [self hiddenFollowPlayerViewAnimation:YES];
            });
        }];
    }];

}

- (void)hiddenFollowPlayerViewAnimation:(BOOL)animaiton {
    CGFloat width = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}].width + 56 + 10 + 20;
    width = width > 200 ? width : 200;
    @weakify(self);
    [self releaseDismissDispose];
    self.dismissDispose = [[RACScheduler mainThreadScheduler] afterDelay:.0 schedule:^{
        @strongify(self);
        [UIView animateWithDuration:.3 animations:^{
            @strongify(self);
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.width.mas_equalTo(width);
                make.right.mas_equalTo(self.superview.mas_right).offset(width);
            }];
            [self layoutIfNeeded];
        }                completion:^(BOOL finished) {
            @strongify(self);
            self.hidden = YES;
        }];

    }];

}

- (void)updateSeleted:(BOOL)isSelected {
    _followButton.selected = isSelected;
}


@end

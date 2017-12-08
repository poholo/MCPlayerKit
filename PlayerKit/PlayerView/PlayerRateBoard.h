//
// Created by majiancheng on 2017/3/27.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PlayerConfig.h"

@protocol PlayerRateBoardDelegate <NSObject>

- (void)changeRate:(CGFloat)rate;

- (void)laterPlay;

- (void)changeCircle:(BOOL)isCircle;

- (void)feedBack;

- (void)actionFeedBack;

- (void)showAirplay;

@end


@interface PlayerRateBoard : UIView {
    UIView *_backView;
    UIButton *_latePlayBtn;
    UIButton *_portraitBtn;
    UIButton *_circleBtn;
    UIButton *_airplayBtn;
    UIButton *_reportBtn;
    UIButton *_feedBackBtn;

    UIView *_rateBgView;
    UILabel *_titleLbel;
    UIButton *_xdot5Btn;
    UIButton *_x1rateBtn;
    UIButton *_x1dot5Btn;
    UIButton *_x2dotBtn;

    UIButton *_befSelectBtn;
}

@property(nonatomic, weak) id <PlayerRateBoardDelegate> delegate;

- (void)setPlayerStyle:(PlayerStyle)playerStyle;

- (void)canShowCircle:(BOOL)circle;

- (void)circle:(BOOL)isCircle;

- (void)selectRate:(CGFloat)rate;

@end

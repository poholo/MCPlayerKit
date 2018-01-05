//
//  PlayerView.m
//  WaQuVideo
//
//  Created by majiancheng on 2017/3/17.
//  Copyright © 2017年 mjc inc. All rights reserved.
//

#import "PlayerBaseView.h"


@implementation PlayerBaseView

@synthesize playerStyle = _playerStyle;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)updatePlayerView:(UIView *)drawPlayerView {
    if (_drawView) {
        [_drawView removeFromSuperview];
        _drawView = nil;
    }
    _drawView = drawPlayerView;
    if (_drawView) {
        [_contentView addSubview:_drawView];
        _drawView.frame = CGRectMake(0, 0, CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame));
    }
}

- (void)updatePlayerLayer:(CALayer *)layer {
    if (_drawView == nil) {
        _drawView = [[UIView alloc] initWithFrame:self.bounds];
        [_contentView addSubview:_drawView];
        [_contentView sendSubviewToBack:_drawView];
    }
    if (_drawLayer) {
        [_drawLayer removeFromSuperlayer];
        _drawLayer = nil;
    }

    _drawLayer = layer;

    if (_drawLayer) {
        [_drawView.layer insertSublayer:_drawLayer atIndex:0];
        _drawLayer.frame = CGRectMake(0, 0, CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame));
    }
}

- (void)prepareUI {
    _contentView = [UIView new];
    [self addSubview:_contentView];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    CGFloat width = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat height = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    switch (self.playerStyle) {
        case PlayerStyleSizeClassRegularHalf: {
            frame = CGRectMake(0, 0, width, width * 16 / 9.0f);
        }
            break;
        case PlayerStyleSizeClassRegular: {
            frame = CGRectMake(0, 0, width, height);
        }
            break;
        case PlayerStyleSizeClassCompact : {
            frame = CGRectMake(0, 0, height, width);
        }
            break;
        case PlayerStyleSizeRegularAuto : {
            frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        }
            break;

    }
    _contentView.frame = frame;
    _drawView.frame = frame;
    _drawLayer.frame = frame;
}

@end

//
//  PlayerView.m
//  litttleplayer
//
//  Created by majiancheng on 2017/3/17.
//  Copyright © 2017年 mjc inc. All rights reserved.
//

#import "MCPlayerView.h"


@implementation MCPlayerView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self prepareUI];
        self.clipsToBounds = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
        self.clipsToBounds = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self prepareUI];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)updatePlayerView:(UIView *)drawPlayerView {
    if (_drawLayer) {
        [_drawLayer removeFromSuperlayer];
        _drawLayer = nil;
    }

    if (_glView == drawPlayerView)
        return;

    _glView = drawPlayerView;
    if (_glView) {
        [self addSubview:_glView];
        _glView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    }
}

- (void)updatePlayerLayer:(CALayer *)layer {
    if (_glView) {
        [_glView removeFromSuperview];
        _glView = nil;
    }

    if (_drawLayer == layer)
        return;

    _drawLayer = layer;

    if (_drawLayer) {
        [self.layer insertSublayer:_drawLayer atIndex:0];
        _drawLayer.frame = CGRectMake(0, 0, CGRectGetWidth(_drawLayer.frame), CGRectGetHeight(_drawLayer.frame));
    }
}

- (void)prepareUI {
    self.backgroundColor = [UIColor blackColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    _drawLayer.frame = frame;
    _glView.frame = frame;
}
@end

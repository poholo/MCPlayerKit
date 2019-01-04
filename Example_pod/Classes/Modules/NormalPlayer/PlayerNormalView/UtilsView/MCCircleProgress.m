//
//  MCCircleProgress.m
//  DrewTest
//
//  Created by majiancheng on 2017/3/17.
//  Copyright © 2017年 poholo Inc. All rights reserved.
//

#import "MCCircleProgress.h"

@interface MCCircleProgress ()

@property(nonatomic, strong) CAShapeLayer *trackLayer;
@property(nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation MCCircleProgress
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self createViews];
    [self addLayout];
}

- (void)createViews {
    [self.layer addSublayer:self.trackLayer];
}

- (void)addLayout {
    self.trackLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    CGPoint center = CGPointMake(CGRectGetWidth(self.frame) / 2.0f, CGRectGetWidth(self.frame) / 2.0f);
    UIBezierPath *trackpath = [UIBezierPath bezierPathWithArcCenter:center radius:self.frame.size.width / 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    self.trackLayer.path = trackpath.CGPath;
}

- (UIBezierPath *)bbbbRate:(CGFloat)rate {
    _rate = rate;
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame) / 2.0f, CGRectGetWidth(self.frame) / 2.0f);
    UIBezierPath *progresspath = [UIBezierPath bezierPathWithArcCenter:center radius:self.frame.size.width / 2 startAngle:-M_PI_2 endAngle:rate * M_PI * 2 - M_PI_2 clockwise:YES];

    _progressLayer.path = progresspath.CGPath;

    return progresspath;
}

- (void)setRate:(CGFloat)rate {
    _rate = rate;
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame) / 2.0f, CGRectGetWidth(self.frame) / 2.0f);
    UIBezierPath *progresspath = [UIBezierPath bezierPathWithArcCenter:center radius:self.frame.size.width / 2 startAngle:-M_PI_2 endAngle:rate * M_PI * 2 - M_PI_2 clockwise:YES];

    _progressLayer.path = progresspath.CGPath;
}

- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    _progressLayer.strokeColor = progressColor.CGColor;
}

- (void)setTrackColor:(UIColor *)trackColor {
    _trackLayer.strokeColor = trackColor.CGColor;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _trackLayer.lineWidth = lineWidth;
    _lineWidth = lineWidth;
    _progressLayer.lineWidth = lineWidth;
}

- (void)start {
    [self.layer addSublayer:[self progressLayer]];
//    
//    CABasicAnimation * frameAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    frameAnim.duration = 1.0;
//    frameAnim.repeatCount = 1;
//    frameAnim.removedOnCompletion = YES;
//    frameAnim.fromValue  = @(1);
//    frameAnim.toValue = @(1.3);
//    [_progressLayer addAnimation:frameAnim forKey:@"scale-layer"];
//    [_trackLayer addAnimation:frameAnim forKey:@"scale-layer"];

    CABasicAnimation *circleAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    circleAnim.removedOnCompletion = YES;
    circleAnim.duration = _seconds;
    circleAnim.fromValue = @(0);
    circleAnim.toValue = @(1);
    circleAnim.repeatCount = self.repeat ? NSIntegerMax : 1;

    [_progressLayer addAnimation:circleAnim forKey:@"strokeEnda"];
}

- (void)pause {
    CFTimeInterval pausedTime = [_progressLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    _progressLayer.speed = 0.0;
    _progressLayer.timeOffset = pausedTime;
}

- (void)resume {
    CFTimeInterval pausedTime = [_progressLayer timeOffset];
    _progressLayer.speed = 1.0;
    _progressLayer.timeOffset = 0.0;
    _progressLayer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [_progressLayer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    _progressLayer.beginTime = timeSincePause;
}

- (void)stop {
    [_progressLayer removeAnimationForKey:@"strokeEnda"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addLayout];
}

#pragma mark - getter


- (CAShapeLayer *)progressLayer {
    if (_progressLayer) {
        [_progressLayer removeAllAnimations];
        [_progressLayer removeFromSuperlayer];
        _progressLayer = nil;
    }
    _progressLayer = [[CAShapeLayer alloc] init];
    _progressLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    //        UIBezierPath * progresspath = [UIBezierPath bezierPathWithArcCenter:self.center radius:self.frame.size.width / 2 startAngle:0 endAngle:0 clockwise:YES];
    if (_lineWidth > 0) {
        _progressLayer.lineWidth = _lineWidth;
        _progressLayer.strokeColor = _progressColor.CGColor;
    }
    _progressLayer.fillColor = nil;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.path = [self bbbbRate:1.0].CGPath;
    _progressLayer.strokeStart = 0.0f;
    _progressLayer.strokeEnd = 1.0f;

    return _progressLayer;
}

- (CAShapeLayer *)trackLayer {
    if (!_trackLayer) {
        _trackLayer = [CAShapeLayer new];
        _trackLayer.fillColor = nil;

    }
    return _trackLayer;
}

@end

//
// Created by littleplayer on 16/5/5.
// Copyright (c) 2016 mjc inc. All rights reserved.
//


#import "MCPlayerLoadingView.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <MCStyle/MCStyleDef.h>

#import "MCCircleProgress.h"
#import "MCPlayerKitDef.h"

@interface MCPlayerLoadingView ()

@property(nonatomic, strong) MCCircleProgress *progressView;
@property(nonatomic, strong) UIImageView *loadingImageView;

@property(nonatomic, assign) CGFloat progress;

@end

@implementation MCPlayerLoadingView

- (void)dealloc {
    MCLog(@"[PK]%@ dealloc", NSStringFromClass(self.class));
    [self disposeHUD];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)disposeHUD {
    [self.progressView stop];
    [self.progressView removeFromSuperview];
}

- (void)setup {
    [self createViews];
    [self addLayout];
}

- (void)createViews {
    [self addSubview:self.loadingImageView];
    [self addSubview:self.progressView];
    self.hidden = YES;
    self.clipsToBounds = YES;
}

- (void)addLayout {
    self.loadingImageView.frame = self.bounds;
    self.progressView.center = self.loadingImageView.center;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addLayout];
}

/** loading有背景图 */
- (void)startRotating {
    if (self.hidden == NO) return;
    self.hidden = NO;
    self.loadingImageView.hidden = NO;
    [self.progressView start];
}

/** loading无背景图 */
- (void)startRotatingNoBg {
    if (self.hidden == NO) return;
    self.hidden = NO;
    self.loadingImageView.hidden = YES;
    [self.progressView start];
}

- (void)endRotating {
    if (self.hidden) return;
    self.hidden = YES;
    [self disposeHUD];
}

- (void)updatePlayerPicture:(NSString *)url {
    [self.loadingImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[MCStyle customImage:@"player_loading_default"]];
}

- (void)hiddenRotateLoadingView:(BOOL)hiddenRotateLoadingView {
    self.progressView.hidden = hiddenRotateLoadingView;
}

#pragma mark - getter

- (UIImageView *)loadingImageView {
    if (!_loadingImageView) {
        _loadingImageView = [[UIImageView alloc] initWithImage:[MCStyle customImage:@"player_loading_default"]];
        _loadingImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _loadingImageView;
}

- (MCCircleProgress *)progressView {
    if (!_progressView) {
        _progressView = [[MCCircleProgress alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _progressView.trackColor = [MCColor custom:@"player_circle_progress_bgcolor"];
        _progressView.lineWidth = 2;
        _progressView.seconds = 2;
        _progressView.repeat = YES;
        _progressView.progressColor = [MCColor custom:@"player_circle_progress_track_color"];
    }
    return _progressView;
}
@end



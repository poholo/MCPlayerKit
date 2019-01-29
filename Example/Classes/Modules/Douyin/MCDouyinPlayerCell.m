//
// Created by majiancheng on 2018/12/27.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "MCDouyinPlayerCell.h"

#import "MCDouyinPlayerView.h"

@implementation MCDouyinPlayerCell

- (void)updatePlayerView:(__weak MCDouyinPlayerView *)playerView {
    [self.contentView addSubview:playerView];
}


+ (CGFloat)height {
    return CGRectGetHeight([UIScreen mainScreen].bounds);
}
@end
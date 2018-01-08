//
// Created by majiancheng on 08/01/2018.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "PlayerSimpleViewCell.h"
#import "PlayerSimpleView.h"
#import "View+MASAdditions.h"

@interface PlayerSimpleViewCell ()

@property(nonatomic, assign) PlayerSimpleView *playerView;

@end

@implementation PlayerSimpleViewCell {

}

- (void)updatePlayerView:(PlayerSimpleView *)playerView {
    if (self.playerView) {
        [self.playerView removeFromSuperview];
    }
    self.playerView = playerView;
    [self.contentView addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

+ (CGFloat)height {
    CGSize size = [UIScreen mainScreen].bounds.size;
    return MIN(size.width, size.height) * 9 / 16;
}

@end
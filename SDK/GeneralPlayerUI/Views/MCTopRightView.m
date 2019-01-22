//
// Created by majiancheng on 2019/1/22.
// Copyright (c) 2019 majiancheng. All rights reserved.
//

#import <MCStyle/MCStyle.h>
#import "MCTopRightView.h"

#import "MCPlayerCommonButton.h"

@interface MCTopRightView ()

@property(nonatomic, strong) NSMutableArray<MCPlayerCommonButton *> *customViews;
@property(nonatomic, assign) MCPlayerStyleSizeType styleSizeType;

@end

@implementation MCTopRightView

- (void)addSubview:(UIView *)view {
}

- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview {
}

- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview {
}


- (void)addCustom:(MCPlayerCommonButton *)customView {
    if (![customView isKindOfClass:[MCPlayerCommonButton class]]) return;
    [self.customViews addObject:customView];
    [super addSubview:customView];
    self.customViews = [[self.customViews sortedArrayUsingComparator:^NSComparisonResult(MCPlayerCommonButton *b0, MCPlayerCommonButton *b1) {
        if (b0.tag > b1.tag) {
            return NSOrderedAscending;
        } else if (b0.tag == b1.tag) {
            return NSOrderedSame;
        } else {
            return NSOrderedDescending;
        }
    }] mutableCopy];

}

- (void)resizeViews {
    CGRect bFrame = CGRectZero;
    for (MCPlayerCommonButton *cview in self.customViews) {
        if ((self.styleSizeType == PlayerStyleSizeClassRegularHalf && cview.showHalfScreen)
                || (self.styleSizeType != PlayerStyleSizeClassRegularHalf && cview.showFullScreen)) {
            CGFloat top = (CGRectGetHeight(self.frame) - cview.size.height) / 2.0f;
            cview.frame = CGRectMake(CGRectGetMaxX(bFrame) + [MCStyle contentInsetIII].left, top, cview.size.width, cview.size.height);
            bFrame = cview.frame;
            cview.hidden = NO;
        } else {
            cview.hidden = YES;
        }
    }

    CGFloat maxX = CGRectGetMaxX(bFrame) + [MCStyle contentInsetII].right;
    CGRect frame = self.frame;
    frame.size.width = maxX;
    self.frame = frame;
}

- (void)updatePlayerStyle:(MCPlayerStyleSizeType)styleSizeType {
    self.styleSizeType = styleSizeType;
    [self resizeViews];
}


- (NSMutableArray *)customViews {
    if (!_customViews) {
        _customViews = [NSMutableArray new];
    }
    return _customViews;
}
@end
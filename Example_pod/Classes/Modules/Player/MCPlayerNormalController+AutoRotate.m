//
// Created by majiancheng on 2018/1/6.
// Copyright (c) 2018 majiancheng. All rights reserved.
//


#import "MCPlayerNormalController+AutoRotate.h"

#import "MCPlayerKit.h"
#import <Masonry.h>

#import "MCPlayerNormalView.h"


@implementation MCPlayerNormalController (AutoRotate)

#pragma mark - AutoRoate

- (BOOL)canRotate {
    if ([self.playerView isLock]) {
        return NO;
    }
    return YES;
}

- (BOOL)isSizeClassRegular {
    //如果是横屏全屏切换给切换机会
//    if (self.playerView.playerStyle == PlayerStyleSizeClassCompact) {
//        return NO;
//    }

    CGSize naturalSize = self.playerKit.naturalSize;
    if (naturalSize.width < naturalSize.height) {
        return YES;
    }
    return NO;
}


#pragma mark - IOS 5 Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

#pragma mark - IOS 6 Rotation

- (BOOL)shouldAutorotate {
    return [self canRotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma IOS8 横竖屏

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context) {
        if (newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) { //横屏
            [self rotate2Landscape];
        } else { //竖屏
            [self rotate2Portrait];
        }

    }                            completion:nil];
}


#pragma mark -

//横屏
- (void)rotate2Landscape {
//    if(self.playerView.playerStyle == PlayerStyleSizeClassCompact) {
//        return;
//    }
//    [self.playerView setPlayerStyle:PlayerStyleSizeClassCompact];
    [self.playerView updateFullScreenBtnStatus:YES];
    [self setStatusBarHidden:YES];

    CGSize size = [UIScreen mainScreen].bounds.size;
    [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(MIN(size.width, size.height));
    }];

    [self.playerView setNeedsUpdateConstraints];
    [self.playerView updateConstraintsIfNeeded];
    [self.playerView layoutIfNeeded];
}

//竖屏
- (void)rotate2Portrait {
//    [self.playerView setPlayerStyle:PlayerStyleSizeClassRegularHalf];
    [self.playerView updateFullScreenBtnStatus:NO];
    [self setStatusBarHidden:NO];

    CGSize size = [UIScreen mainScreen].bounds.size;
    [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(MIN(size.width, size.height) * 9 / 16);
    }];
    [self.playerView setNeedsUpdateConstraints];
    [self.playerView updateConstraintsIfNeeded];
    [self.playerView layoutIfNeeded];
}

- (void)rotate2PortraitFullScreen {
//    [self.playerView setPlayerStyle:PlayerStyleSizeClassRegular];
    [self.playerView updateFullScreenBtnStatus:YES];
    [self setStatusBarHidden:YES];

    CGSize size = [UIScreen mainScreen].bounds.size;
    [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(MAX(size.width, size.height));
    }];
    [self.playerView setNeedsUpdateConstraints];
    [self.playerView updateConstraintsIfNeeded];
    [self.playerView layoutIfNeeded];
}

- (void)setStatusBarHidden:(BOOL)isHidden {
    [[UIApplication sharedApplication] setStatusBarHidden:isHidden withAnimation:YES];
}

- (void)setViewOrientation {

}

- (void)changePlayerRotate {
//    switch (self.playerView.playerStyle) {
//        case PlayerStyleSizeClassRegular : {
//            [self updatePlayerRegularHalf];
//        }
//            break;
//        case PlayerStyleSizeClassCompact : {
//            [self updatePlayerRegularHalf];
//        }
//            break;
//        case PlayerStyleSizeClassRegularHalf : {
//            [self updatePlayerRegular];
//        }
//            break;
//        default : {
//        }
//            break;
//
//    }
    [self.view layoutIfNeeded];
}

//设置横竖屏

- (void)updatePlayerRegularHalf {
    //横屏时切换竖屏
//    if (/*[self isSizeClassRegular] &&*/ self.playerView.playerStyle == PlayerStyleSizeClassRegular) {
//        [self rotate2Portrait];
//        return;
//    }
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    [self setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)updatePlayerRegular {
//    if ([self isSizeClassRegular] && self.playerView.playerStyle == PlayerStyleSizeClassRegularHalf) {
//        [self rotate2PortraitFullScreen];
//        return;
//    }
    //竖屏时切换成横屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    [self setStatusBarHidden:YES];
}

- (void)updatePlayerCompact {
    //横屏时切换竖屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    [self setStatusBarHidden:NO];

}
@end

//
// Created by majiancheng on 2018/1/6.
// Copyright (c) 2018 majiancheng. All rights reserved.
//


#import "MCPlayerNormalController+AutoRotate.h"

#import "MCPlayerKit.h"

#import "MCPlayerNormalView.h"
#import "MCRotateHelper.h"


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
    if(self.playerView.styleSizeType == PlayerStyleSizeClassCompact) {
        return;
    }
    [MCRotateHelper setStatusBarHidden:YES];

    [self.playerView updatePlayerStyle:PlayerStyleSizeClassCompact];
    self.playerView.frame = self.view.bounds;
}

//竖屏
- (void)rotate2Portrait {
    [MCRotateHelper setStatusBarHidden:NO];
    CGSize size = [UIScreen mainScreen].bounds.size;
    [self.playerView updatePlayerStyle:PlayerStyleSizeClassRegularHalf];
    self.playerView.frame = CGRectMake(0, 0, size.width, size.width * 9 / 16);
}

- (void)rotate2PortraitFullScreen {
    [MCRotateHelper setStatusBarHidden:YES];
    [self.playerView updatePlayerStyle:PlayerStyleSizeClassRegular];
    self.playerView.frame = self.view.bounds;
}

@end

//
// Created by majiancheng on 2019/1/3.
// Copyright (c) 2019 majiancheng. All rights reserved.
//

#import "MCNavigationController.h"


@implementation MCNavigationController

- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.visibleViewController preferredStatusBarStyle];
}

@end
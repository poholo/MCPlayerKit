//
// Created by Jiangmingz on 2017/3/16.
// Copyright (c) 2017 挖趣智慧科技（北京）有限公司. All rights reserved.
//

#import "MMWindowController.h"

#import "MMPopupWindow.h"
#import "AppDelegate.h"
#import "MMPopupDefine.h"

@implementation MMWindowController

- (void)setView:(UIView *)view {
    [super setView:view];

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
#ifdef __IPHONE_7_0
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    /** this line is important. this tells the view controller to not resize
     the view to display the status bar -- unless we're on iOS 7 -- in
     which case it's deprecated and does nothing */
    [self setWantsFullScreenLayout:YES];
#endif
#endif
#endif

}

- (UIWindow *)currentWindow {
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    return appDelegate.window;
}

- (BOOL)oldRootViewControllerShouldRotateToOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    BOOL shouldRotateToOrientation = NO;
    UIViewController *rootViewController = [[self currentWindow] rootViewController];
    suppressDeprecation(
            if ([[self superclass] instancesRespondToSelector:@selector(presentedViewController)] &&
                    ([rootViewController presentedViewController] != nil)) {
                shouldRotateToOrientation = [rootViewController.presentedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
            }

            if ((shouldRotateToOrientation == NO) &&
                    (rootViewController != nil)) {

                shouldRotateToOrientation = [rootViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
            } else if (rootViewController == nil) {
                shouldRotateToOrientation = [super shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
            }
    );

    return shouldRotateToOrientation;
}

/** The rotation callbacks for this view controller will never get fired on iOS <5.0. This must be related to creating a view controller in a new window besides the default keyWindow. Since this is the case, the manual method of animating the rotating the view's transform is used via notification observers added in setView: above.

 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if ([self.view.window isKindOfClass:[MMPopupWindow class]]) {
        return [self oldRootViewControllerShouldRotateToOrientation:toInterfaceOrientation];;
    } else {
        return [super shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *rootViewController = [[self currentWindow] rootViewController];
    if ([rootViewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
        return [rootViewController supportedInterfaceOrientations];
    }

    return [super supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate {
    UIViewController *rootViewController = [[self currentWindow] rootViewController];
    if ([rootViewController respondsToSelector:@selector(shouldAutorotate)]) {
        return [rootViewController shouldAutorotate];
    }

    return [super shouldAutorotate];
}

- (UIStatusBarStyle)preferredStatusBarStyle NS_EXTENSION_UNAVAILABLE_IOS("Not available in app extensions.") {
    return [[UIApplication sharedApplication] statusBarStyle];
}

- (BOOL)prefersStatusBarHidden NS_EXTENSION_UNAVAILABLE_IOS("Not available in app extensions.") {
    return [[UIApplication sharedApplication] isStatusBarHidden];
}

@end

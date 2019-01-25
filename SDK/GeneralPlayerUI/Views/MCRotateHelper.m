//
// Created by majiancheng on 2019/1/2.
// Copyright (c) 2019 majiancheng. All rights reserved.
//

#import "MCRotateHelper.h"


@implementation MCRotateHelper

+ (void)setStatusBarHidden:(BOOL)isHidden {
    [[UIApplication sharedApplication] setStatusBarHidden:isHidden withAnimation:YES];
}

+ (void)updatePlayerRegularHalf {
    [MCRotateHelper updateOrientation:UIInterfaceOrientationPortrait];
    [self setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

+ (void)updatePlayerRegular {
    [MCRotateHelper updateOrientation:UIInterfaceOrientationPortrait];
    [self setStatusBarHidden:NO];
}

+ (void)updatePlayerCompact {
    [MCRotateHelper updateOrientation:UIInterfaceOrientationLandscapeRight];
    [self setStatusBarHidden:YES];
}

+ (void)updateOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = interfaceOrientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

@end
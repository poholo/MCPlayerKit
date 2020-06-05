//
// Created by majiancheng on 2019/11/5.
// Copyright (c) 2019 GymChina Inc. All rights reserved.
//

#import "MCImpactFeedbackGeneratorUtils.h"

#import <UIKit/UIKit.h>


@implementation MCImpactFeedbackGeneratorUtils

+ (void)responseFeedBackGenderator {
    if (@available(iOS 11.0, *)) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [feedBackGenertor impactOccurred];
    }
}

@end

//
// Created by majiancheng on 2019/1/22.
// Copyright (c) 2019 majiancheng. All rights reserved.
//

#import "MCPlayerCommonButton.h"


@implementation MCPlayerCommonButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.showFullScreen = YES;
    self.showHalfScreen = YES;
}
@end
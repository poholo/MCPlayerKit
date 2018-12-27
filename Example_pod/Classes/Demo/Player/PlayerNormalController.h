//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "MCController.h"

@class PlayerNormalView;
@class MCPlayerKit;


@interface PlayerNormalController : MCController

@property(nonatomic, readonly) MCPlayerKit *playerKit;
@property(nonatomic, readonly) PlayerNormalView *playerView;

@end
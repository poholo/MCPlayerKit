//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "MCController.h"

@class PlayerNormalView;
@class PlayerKit;


@interface PlayerNormalController : MCController

@property(nonatomic, readonly) PlayerKit *playerKit;
@property(nonatomic, readonly) PlayerNormalView *playerView;

@end
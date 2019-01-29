//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "MCController.h"

@class MCPlayerGeneralView;
@class MCPlayerKit;


@interface MCPlayerGeneralController : MCController

@property(nonatomic, readonly) MCPlayerKit *playerKit;
@property(nonatomic, readonly) MCPlayerGeneralView *playerView;

@end
//
//  MCPlayerGeneralNotTopController.h
//  PlayerKitDemo
//
//  Created by majiancheng on 2020/4/21.
//  Copyright © 2020 majiancheng. All rights reserved.
//

#import "MCController.h"

@class MCPlayerGeneralView;
@class MCPlayerKit;

NS_ASSUME_NONNULL_BEGIN

@interface MCPlayerGeneralNotTopController : MCController

@property(nonatomic, readonly) MCPlayerKit *playerKit;
@property(nonatomic, readonly) MCPlayerGeneralView *playerView;

@end

NS_ASSUME_NONNULL_END

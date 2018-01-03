//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MCControllerProtocol.h"

@class DataVM;


@interface MCController : UIViewController <MCControllerProtocol> {
    DataVM *_dataVM;
}

@property(nonatomic, strong) DataVM *dataVM;

@end
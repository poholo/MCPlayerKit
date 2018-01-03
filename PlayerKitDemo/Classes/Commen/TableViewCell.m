//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "TableViewCell.h"
#import "Dto.h"


@implementation TableViewCell {

}

- (void)loadData:(Dto *)dto {

}

+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}

+ (CGFloat)height {
    return 44.0f;
}

@end
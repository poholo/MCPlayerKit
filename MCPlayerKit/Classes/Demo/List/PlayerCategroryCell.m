//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "PlayerCategroryCell.h"

#import "Dto.h"
#import "PlayerCategroryDto.h"

@interface PlayerCategroryCell ()

@end


@implementation PlayerCategroryCell {

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)loadData:(Dto *)dto {
    [super loadData:dto];
    self.textLabel.text = ((PlayerCategroryDto *) dto).name;
}

@end
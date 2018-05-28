//
// Created by majiancheng on 2018/5/28.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

import Foundation

class PlayerCategroryDto: Dto {
    var name: String
    var info: String
    var actionClass: AnyClass

    init(_ entitiId: String, name: String, info: String, actionClass: AnyClass) {
        self.name = name
        self.info = info
        self.actionClass = actionClass
        super.init(entitiId)
    }

}
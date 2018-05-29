//
// Created by majiancheng on 2018/5/29.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

import Foundation

class PlayerNormalDataVM: DataVM {
    override func refresh() {
        super.refresh()
        let playerNormalDto: PlayerNormalDto = PlayerNormalDto("16:9")
        self.dataList.append(playerNormalDto)
    }
}
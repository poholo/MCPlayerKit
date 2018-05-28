//
// Created by majiancheng on 2018/5/28.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

import Foundation

class PlayerCategroiesDataVM: DataVM {
    override func refresh() {
        super.refresh()
        let dto: Dto = PlayerCategroryDto("1", name: "16:9 固定模式", info: "", actionClass: PlayerCategroryDto.self)
        self.dataList.append(dto)

        let dto2: Dto = PlayerCategroryDto("2", name: "TableView 滚动", info: "", actionClass: PlayerCategroryDto.self)
        self.dataList.append(dto2)


        let dto3: Dto = PlayerCategroryDto("3", name: "CollectionView 滚动", info: "", actionClass: PlayerCategroryDto.self)
        self.dataList.append(dto3)

        let dto4: Dto = PlayerCategroryDto("4", name: "ScrollView 滚动 + 小窗切换", info: "", actionClass: PlayerCategroryDto.self)
        self.dataList.append(dto4)

        let dto5: Dto = PlayerCategroryDto("5", name: "Music player", info: "", actionClass: PlayerCategroryDto.self)
        self.dataList.append(dto5)

        let dto6: Dto = PlayerCategroryDto("6", name: "全局播放器", info: "", actionClass: PlayerCategroryDto.self)
        self.dataList.append(dto6)

    }
}
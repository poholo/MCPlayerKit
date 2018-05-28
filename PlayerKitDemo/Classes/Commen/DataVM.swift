//
// Created by majiancheng on 2018/5/24.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

import Foundation

class DataVM {
    var dataList: Array<Dto>!
    var isRefresh = false

    init() {
        self.dataList = Array<Dto>()
    }

    func refresh() {
        self.isRefresh = true
    }

}
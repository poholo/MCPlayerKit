//
// Created by majiancheng on 2018/5/28.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

import UIKit

class TableViewcell: UITableViewCell {
    func loadData(data: Dto) {

    }

    class func identifier() -> String {
        return String(describing: self)
    }

    class func height() -> CGFloat {
        return 44
    }

}
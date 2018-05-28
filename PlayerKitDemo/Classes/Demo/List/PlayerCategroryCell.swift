//
// Created by majiancheng on 2018/5/28.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

import UIKit

class PlayerCategroryCell: TableViewcell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func loadData(data: Dto) {
        super.loadData(data: data)
        let dto = data as! PlayerCategroryDto
        self.textLabel!.text = dto.name
    }
}
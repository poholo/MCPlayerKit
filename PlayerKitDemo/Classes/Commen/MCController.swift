//
// Created by majiancheng on 2018/5/24.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

import UIKit

class MCController: UIViewController {
    var dataVM: DataVM!
    var params: Dictionary<String, Any>!

    convenience init() {
        self.init(params: Dictionary())
    }

    init(params: Dictionary<String, Any>) {
        self.params = params;
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
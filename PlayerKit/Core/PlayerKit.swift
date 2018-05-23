//
// Created by majiancheng on 2018/5/23.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

import Foundation


class PlayerKit {
    weak var playerView: UIView?
    var player: Player {
        set {
            self.player = newValue
        }
        get {
            if self.player == NULL {
                self.player = Player()
            }
            return self.player
        }
    }

}
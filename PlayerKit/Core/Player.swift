//
// Created by majiancheng on 2018/5/23.
// Copyright (c) 2018 majiancheng. All rights reserved.
//


import Foundation

enum PlayerStatus {
    case Unknow, Loading, Caching, Seeking, Playing, Pausing, Error
}

enum PlayerCategory {
    case PlayerCategoryAVPlayer, PlayerCategoryIJKPlayer
}

protocol PlayerProtocol {

    var rate: Float = 1.0

    func playURL(url: String)
    func play()
    func pause()
    func currentTime() -> TimeInterval
    func duration() -> TimeInterval
    func seek(time: TimeInterval)
    func updateFrame(frame: CGRect)
    func destory()

}

class Player: PlayerProtocol {
    var playerStatus: PlayerStatus
    var drawView: UIView

    var rate: Float {
        set {
            self.rate = newValue
        }
        get {
            return self.rate
        }
    }
    init() {
        self.playerStatus = PlayerStatus.Unknow
        self.drawView = UIView(frame: CGRect.zero)
    }

    func playURL(url: String) {

    }

    func play() {
    }

    func pause() {
    }

    func status() -> PlayerStatus {
        return self.playerStatus
    }

    func currentTime() -> TimeInterval {
    }

    func duration() -> TimeInterval {
    }

    func seek(time: TimeInterval) {
    }

    func updateFrame(frame: CGRect) {
        self.drawView.frame = frame
    }

    func destory() {
        self.drawView.removeFromSuperview()
    }
}
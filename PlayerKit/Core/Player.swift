//
// Created by majiancheng on 2018/5/23.
// Copyright (c) 2018 majiancheng. All rights reserved.
//


import Foundation

public enum PlayerStatus {
    case Unknow, Loading, Caching, Seeking, Playing, Pausing, Error
}

public enum PlayerCategory {
    case PlayerCategoryAVPlayer, PlayerCategoryIJKPlayer
}

protocol PlayerProtocol {

    var rate: Float { set get }

    func playURL(url: String)
    func play()
    func pause()
    func currentTime() -> TimeInterval
    func duration() -> TimeInterval
    func seek(time: TimeInterval)
    func updateFrame(frame: CGRect)
    func destory()

}

open class Player: PlayerProtocol {
    open var playerStatus: PlayerStatus
    open var drawView: UIView

    open var rate: Float {
        set {
            self.rate = newValue
        }
        get {
            return self.rate
        }
    }

    public init() {
        self.playerStatus = PlayerStatus.Unknow
        self.drawView = UIView(frame: CGRect.zero)
    }

    open func playURL(url: String) {

    }

    open func play() {
    }

    open func pause() {
    }

    open func status() -> PlayerStatus {
        return self.playerStatus
    }

    open func currentTime() -> TimeInterval {
        return 0
    }

    open func duration() -> TimeInterval {
        return 0
    }

    open func seek(time: TimeInterval) {

    }

    open func updateFrame(frame: CGRect) {
        self.drawView.frame = frame
    }

    open func destory() {
        self.drawView.removeFromSuperview()
    }
}

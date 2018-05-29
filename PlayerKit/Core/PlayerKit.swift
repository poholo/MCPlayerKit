//
// Created by majiancheng on 2018/5/23.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

import Foundation


public enum PlayerCoreType {
    case CoreAVPlayer
    case CoreIJKPlayer
}

open class PlayerKit: PlayerProtocol {
    weak open var playerView: PlayerBaseView?
    open var player: Player?
    open var coreType: PlayerCoreType = PlayerCoreType.CoreAVPlayer
    open var timer: Timer?

    open var rate: Float {
        get {
            return self.player!.rate
        }
        set {
            self.player!.rate = newValue
        }
    }

    open func playURL(url: String) {
        self.destory()

        switch self.coreType {
        case .CoreAVPlayer:
            self.player = AVPlayerX()
        case .CoreIJKPlayer:
            self.player = AVPlayerX()
        }

        self.player!.playURL(url: url)
        self.playerView!.addSubview(self.player!.drawView)
    }

    open func play() {
        self.player!.play()
    }

    open func pause() {
        self.player!.pause()
    }

    open func currentTime() -> TimeInterval {
        return self.player!.currentTime()
    }

    open func duration() -> TimeInterval {
        return self.player!.duration()
    }

    open func seek(time: TimeInterval) {
        self.player!.seek(time: time)
    }

    open func updateFrame(frame: CGRect) {
        self.player!.updateFrame(frame: frame)
    }

    open func destory() {
        self.invlidateTime()
        self.playerView!.willRemoveSubview(self.player!.drawView)
        self.player!.destory()

    }

    private func startTime() {
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: Selector("timeTick"), userInfo: nil, repeats: true)
        }
    }

    private func invlidateTime() {
        if self.timer != nil {
            self.timer!.invalidate()
            self.timer = nil
        }
    }

    private func timeTick() {
        print("\(self.currentTime()) - \(self.duration())")
    }
}

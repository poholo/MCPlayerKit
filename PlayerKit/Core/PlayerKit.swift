//
// Created by majiancheng on 2018/5/23.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

import Foundation


enum PlayerCoreType {
    case CoreAVPlayer
    case CoreIJKPlayer
}

class PlayerKit: PlayerProtocol {
    weak var playerView: PlayerBaseView?
    var player: Player?
    var coreType: PlayerCoreType = PlayerCoreType.CoreAVPlayer
    var timer: Timer?

    var rate: Float {
        get {
            return self.player!.rate
        }
        set {
            self.player!.rate = newValue
        }
    }

    func playURL(url: String) {
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

    func play() {
        self.player!.play()
    }

    func pause() {
        self.player!.pause()
    }

    func currentTime() -> TimeInterval {
        return self.player!.currentTime()
    }

    func duration() -> TimeInterval {
        return self.player!.duration()
    }

    func seek(time: TimeInterval) {
        self.player!.seek(time: time)
    }

    func updateFrame(frame: CGRect) {
        self.player!.updateFrame(frame: frame)
    }

    func destory() {
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
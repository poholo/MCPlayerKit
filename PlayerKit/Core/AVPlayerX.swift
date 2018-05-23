//
// Created by majiancheng on 2018/5/23.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

import Foundation
import AVFoundation

class AVPlayerX: Player {
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?

    override var rate: Float {
        get {
            return self.player!.rate
        }
        set {
            self.player!.rate = newValue
        }
    }

    override func playURL(url: String) {
        super.playURL(url: url)
        self.player = AVPlayer(url: URL(string: url)!)
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.drawView.layer.addSublayer(self.playerLayer!)
    }

    override func play() {
        super.play()
        self.player!.play()
    }

    override func pause() {
        super.pause()
        self.player!.pause()
    }

    override func currentTime() -> TimeInterval {
        return Double(self.player!.currentTime().value)
    }

    override func duration() -> TimeInterval {
        return Double(self.player!.currentItem!.duration.value)
    }

    override func seek(time: TimeInterval) {
        self.player!.seek(to: CMTime(seconds: time, preferredTimescale: 1))
    }

    override func updateFrame(frame: CGRect) {
        super.updateFrame(frame: frame)
        self.playerLayer!.frame = CGRect(origin: CGPoint.zero, size: frame.size)
    }

    override func destory() {
        self.pause()
        self.playerLayer!.removeFromSuperlayer()
        self.playerLayer = nil
        self.player = nil

        super.destory()
    }
}
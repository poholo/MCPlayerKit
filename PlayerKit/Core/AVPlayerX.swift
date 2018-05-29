//
// Created by majiancheng on 2018/5/23.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

import Foundation
import AVFoundation

open class AVPlayerX: Player {
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?

    override open var rate: Float {
        get {
            return self.player!.rate
        }
        set {
            self.player!.rate = newValue
        }
    }

    override public init() {
        super.init()

    }

    override open func playURL(url: String) {
        super.playURL(url: url)
        self.player = AVPlayer(url: URL(string: url)!)
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.drawView.layer.addSublayer(self.playerLayer!)
    }

    override open func play() {
        super.play()
        self.player!.play()
    }

    override open func pause() {
        super.pause()
        self.player!.pause()
    }

    override open func currentTime() -> TimeInterval {
        return Double(self.player!.currentTime().value)
    }

    override open func duration() -> TimeInterval {
        return Double(self.player!.currentItem!.duration.value)
    }

    override open func seek(time: TimeInterval) {
        self.player!.seek(to: CMTime(seconds: time, preferredTimescale: 1))
    }

    override open func updateFrame(frame: CGRect) {
        super.updateFrame(frame: frame)
        self.playerLayer!.frame = CGRect(origin: CGPoint.zero, size: frame.size)
    }

    override open func destory() {
        self.pause()
        self.playerLayer!.removeFromSuperlayer()
        self.playerLayer = nil
        self.player = nil

        super.destory()
    }
}

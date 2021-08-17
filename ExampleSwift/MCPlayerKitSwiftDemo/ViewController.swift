//
//  ViewController.swift
//  MCIJKPlayerTest
//
//  Created by poholo on 2021/7/21.
//

import UIKit
import IJKMediaFramework
import MCPlayerKit
import MCStyle

class ViewController: UIViewController {
    let playurl: String = "https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=bea0903abb954f58ac0e17c21226a3c3&line=1&app_id=1115&quality=720p"
    
    var ijk: IJKFFMoviePlayerController?
    
    
    @IBOutlet weak var basePlayerViewBoard: UIView!
    
    deinit {
        destoryPlayerKit()
    }
    func destoryPlayerKit() {
        if playerKit != nil {
            playerKit?.destory()
            playerKit = nil
        }
        if playerView != nil {
            playerView?.removeFromSuperview()
            playerView = nil
        }
    }
    
    func destoryIJK() {
        if ijk != nil {
            ijk?.stop()
            ijk?.view.removeFromSuperview()
            ijk = nil
        }
    }
    
    
    
    @IBAction func ijkTest(_ sender: Any) {
        destoryIJK()
        destoryPlayerKit()
        ijk = IJKFFMoviePlayerController(contentURL: URL(string: playurl), with: .byDefault())
        ijk?.prepareToPlay()
        if let vw = ijk?.view {
            vw.frame = basePlayerViewBoard.bounds
            basePlayerViewBoard.addSubview(vw)
        }
    }
    
    var playerKit: MCPlayerKit?
    var playerView: MCPlayerGeneralView?
    
    @IBAction func mcplayerKitTest(_ sender: Any) {
        destoryIJK()
        destoryPlayerKit()
        playerView = MCPlayerGeneralView(frame: basePlayerViewBoard.bounds)
        playerKit = MCPlayerKit(playerView: playerView?.playerView)
        playerView?.updateAction(playerKit!)
        basePlayerViewBoard.addSubview(playerView!)
        playerKit?.playerCoreType = .ijkPlayer
        playerKit?.playUrls([playurl])
        playerKit?.preparePlay()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStyle
        
    }
}

// style
extension ViewController {
    var updateStyle: Void {
        MCStyleManager.share().colorStyleDataCallback = { () -> [AnyHashable: Any] in
            let path = Bundle.main.path(forResource: "CustomPlayerColor", ofType: "json")
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path!)) {
                if let dictionary: [AnyHashable : Any] = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [AnyHashable : Any] ?? [:] {
                    return dictionary["data"] as? [AnyHashable: Any] ?? [:]
                }
            }
            return [:]
        }
        
        MCStyleManager.share().fontStyleDataCallBack = { () -> [AnyHashable: Any] in
            let path = Bundle.main.path(forResource: "CustomPlayerFont", ofType: "json")
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path!)) {
                if let dictionary: [AnyHashable : Any] = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [AnyHashable : Any] ?? [:] {
                    return dictionary["data"] as? [AnyHashable: Any] ?? [:]
                }
            }
            return [:]
        }
        
        MCStyleManager.share().styleDataCallback = { () -> [AnyHashable: Any] in
            let path = Bundle.main.path(forResource: "CustomPlayerStyle", ofType: "json")
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path!)) {
                if let dictionary: [AnyHashable : Any] = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [AnyHashable : Any] ?? [:] {
                    return dictionary["data"] as? [AnyHashable: Any] ?? [:]
                }
            }
            return [:]
        }
        MCStyleManager.share().loadData()
    }
}


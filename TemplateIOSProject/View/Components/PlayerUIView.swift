//
//  PlayerUIView.swift
//  QuickLifts
//
//  Created by Tremaine Grant on 6/27/23.
//

import Foundation
import SwiftUI
import AVFoundation

class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(frame: .zero)
    
        let player = AVPlayer(url: url)
        player.actionAtItemEnd = .none
        player.play()
        
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)

        layer.addSublayer(playerLayer)
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}

struct PlayerUIView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(url: Bundle.main.url(forResource: "background_video", withExtension: "mov")!)
            .ignoresSafeArea(.all)
    }
}

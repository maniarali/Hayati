//
//  VideoPlayerView.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
//
import SwiftUI
import AVKit
import UIKit

struct VideoPlayerView: UIViewRepresentable {
    let player: AVPlayer
    @Binding var isVisible: Bool
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        context.coordinator.playerLayer = playerLayer
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.playerLayer?.frame = uiView.bounds
        if isVisible {
            player.seek(to: .zero)
            player.play()
            print("Playing video at \(player.currentItem?.asset ?? nil)")
        } else {
            player.pause()
            print("Paused video at \(player.currentItem?.asset ?? nil)")
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var playerLayer: AVPlayerLayer?
    }
}

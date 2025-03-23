//
//  VideoCellView.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
//
import SwiftUI
import AVKit

struct VideoCellView: View {
    let post: Post
    let playbackService: VideoPlaybackService
    @State private var player: AVPlayer?
    @State private var isVisible = false
    
    var body: some View {
        ZStack {
            if let player = player {
                VideoPlayer(player: player)
                    .disabled(true)
                    .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.7)
                    .background(GeometryReader { geo in
                        Color.clear
                            .onAppear { updateVisibility(geo) }
                            .onChange(of: geo.frame(in: .global)) { updateVisibility(geo) }
                    })
            } else {
                Color.gray.opacity(0.2)
                    .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.7)
                    .overlay(ProgressView())
                    .task {
                        player = await playbackService.player(for: post)
                    }
            }
        }
    }
    
    private func updateVisibility(_ geo: GeometryProxy) {
        let frame = geo.frame(in: .global)
        let screenHeight = UIScreen.main.bounds.height
        let fullyVisible = frame.minY >= 0 && frame.maxY <= screenHeight
        
        if fullyVisible != isVisible {
            isVisible = fullyVisible
            if let player = player {
                isVisible ? playbackService.play(player) : playbackService.pause(player)
            }
        }
    }
}

#Preview {
    let cacheService = MediaCacheService()
    let playbackService = VideoPlaybackService(cacheService: cacheService)
    let post = Post(id: "test", media: Media(type: .video, url: URL(string: "https://i.imgur.com/whaRU9D.mp4")!))
    return VideoCellView(post: post, playbackService: playbackService)
}

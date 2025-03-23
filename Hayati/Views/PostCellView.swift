//
//  PostCellView.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
import SwiftUI
import AVKit

struct PostCellView: View {
    let post: Post
    let cacheService: MediaCacheService
    let playbackService: VideoPlaybackService
    @State private var image: UIImage?
    @State private var player: AVPlayer?
    @State private var isVisible = false
    
    var body: some View {
        ZStack {
            switch post.media.type {
            case .photo:
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Color.gray.opacity(0.2)
                        .frame(maxWidth: .infinity, minHeight: 300)
                        .onAppear {
                            Task {
                                image = try? await cacheService.loadImage(from: post.media.url)
                            }
                        }
                }
            case .video:
                if let player = player {
                    VideoPlayer(player: player)
                        .disabled(true)
                        .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.7) // 70% screen height
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
    }
    
    private func updateVisibility(_ geo: GeometryProxy) {
        let frame = geo.frame(in: .global)
        let screenHeight = UIScreen.main.bounds.height
        
        // Video is fully visible if its top (minY) >= 0 and bottom (maxY) <= screenHeight
        let fullyVisible = frame.minY >= 0 && frame.maxY <= screenHeight
        
        if fullyVisible != isVisible {
            isVisible = fullyVisible
            if let player = player {
                isVisible ? playbackService.play(player) : playbackService.pause(player)
            }
        }
    }
}

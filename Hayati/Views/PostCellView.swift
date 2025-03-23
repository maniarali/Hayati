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
                        .frame(maxWidth: .infinity, minHeight: 300)
                        .background(GeometryReader { geo in
                            Color.clear
                                .onAppear { updateVisibility(geo) }
                                .onChange(of: geo.frame(in: .global)) { updateVisibility(geo) }
                        })
                } else {
                    Color.gray.opacity(0.2)
                        .frame(maxWidth: .infinity, minHeight: 300)
                        .overlay(ProgressView())
                        .task {
                            player = await playbackService.player(for: post)
                        }
                }
            }
        }
        .background(Color.black)
    }
    
    private func updateVisibility(_ geo: GeometryProxy) {
        let frame = geo.frame(in: .global)
        let screenHeight = UIScreen.main.bounds.height
        let newVisibility = frame.minY < screenHeight && frame.maxY > 0
        if newVisibility != isVisible {
            isVisible = newVisibility
            if let player = player {
                isVisible ? playbackService.play(player) : playbackService.pause(player)
            }
        }
    }
}

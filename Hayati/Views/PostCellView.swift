//
//  PostCellView.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
import SwiftUI

struct PostCellView: View {
    let post: Post
    let cacheService: MediaCacheService
    let playbackService: VideoPlaybackService
    @State private var images: [URL: UIImage] = [:]
    @State private var currentPage = 0
    
    var body: some View {
        VStack(spacing: 0) {
            if post.media.count == 1 {
                MediaView(media: post.media[0], cacheService: cacheService, playbackService: playbackService)
                    .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.6)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(post.media, id: \.url) { media in
                            MediaView(media: media, cacheService: cacheService, playbackService: playbackService)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.6)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .overlay(alignment: .bottom) {
                    if post.media.count > 1 {
                        HStack(spacing: 6) {
                            ForEach(0..<post.media.count, id: \.self) { index in
                                Circle()
                                    .frame(width: 8, height: 8)
                                    .foregroundColor(index == currentPage ? .white : .gray)
                            }
                        }
                        .padding(.bottom, 8)
                    }
                }
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                        currentPage = min(max(0, currentPage), post.media.count - 1)
                    }
                }
            }
            Divider()
                .background(Color.gray.opacity(0.5))
        }
    }
}

struct MediaView: View {
    let media: Media
    let cacheService: MediaCacheService
    let playbackService: VideoPlaybackService
    @State private var image: UIImage?
    @State private var isVisible = false
    
    var body: some View {
        switch media.type {
        case .photo:
            ZStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Color.gray.opacity(0.2) // Placeholder to maintain size
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear {
                            Task {
                                if let loadedImage = try? await cacheService.loadImage(from: media.url) {
                                    image = loadedImage
                                }
                            }
                        }
                }
            }
        case .video:
            VideoPlayerView(player: playbackService.player(for: media.url), isVisible: $isVisible)
                .background(GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            updateVisibility(geo)
                        }
                        .onChange(of: geo.frame(in: .global)) { newFrame in
                            updateVisibility(geo)
                        }
                })
                .onDisappear {
                    playbackService.removePlayer(for: media.url)
                }
        }
    }
    
    private func updateVisibility(_ geo: GeometryProxy) {
        let frame = geo.frame(in: .global)
        let screenHeight = UIScreen.main.bounds.height
        isVisible = frame.minY < screenHeight && frame.maxY > 0
    }
}

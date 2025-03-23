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
    
    var body: some View {
        switch post.media.type {
        case .photo:
            ImageCellView(post: post, cacheService: cacheService)
        case .video:
            VideoCellView(post: post, playbackService: playbackService)
        }
    }
}

#Preview {
    let cacheService = MediaCacheService()
    let playbackService = VideoPlaybackService(cacheService: cacheService)
    let post = Post(id: "test", media: Media(type: .photo, url: URL(string: "https://i.imgur.com/test.jpg")!))
    return PostCellView(post: post, cacheService: cacheService, playbackService: playbackService)
}

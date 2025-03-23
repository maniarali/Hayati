//
//  ImageCellView.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
//
import SwiftUI

struct ImageCellView: View {
    let post: Post
    let cacheService: MediaCacheService
    @State private var image: UIImage?
    
    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            } else {
                Color.gray.opacity(0.2)
                    .frame(maxWidth: .infinity)
                    .overlay(ProgressView())
                    .onAppear {
                        Task {
                            image = try? await cacheService.loadImage(from: post.media.url)
                        }
                    }
            }
        }
    }
}

#Preview {
    let cacheService = MediaCacheService()
    let post = Post(id: "test", media: Media(type: .photo, url: URL(string: "https://i.imgur.com/B9w2ZO9.png")!))
    return ImageCellView(post: post, cacheService: cacheService)
}

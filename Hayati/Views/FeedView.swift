//
//  FeedView.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
//
import SwiftUI

struct FeedView: View {
    @ObservedObject var viewModel: FeedViewModel
    let cacheService: MediaCacheService
    let playbackService: VideoPlaybackService
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.posts) { post in
                        PostCellView(post: post, cacheService: cacheService, playbackService: playbackService)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
            }
            .navigationTitle("Hayati")
        }
    }
}

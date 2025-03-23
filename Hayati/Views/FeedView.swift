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
            if viewModel.isLoadingInitial {
                ProgressView("Loading Hayati...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(viewModel.posts.enumerated()), id: \.element.id) { index, post in
                            PostCellView(post: post, cacheService: cacheService, playbackService: playbackService)
                                .frame(maxWidth: .infinity, minHeight: 300)
                                .onAppear {
                                    viewModel.loadMorePostsIfNeeded(currentIndex: index)
                                }
                            if index < viewModel.posts.count - 1 {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 8)
                            }
                        }
                        if viewModel.isLoadingMore {
                            ProgressView()
                                .padding()
                        }
                    }
                }
                .background(Color.black)
                .navigationTitle("Hayati")
                .navigationBarTitleDisplayMode(.inline)
                .onDisappear {
                    playbackService.cleanup()
                }
            }
        }
    }
}

#Preview {
    let repository = ImgurPostRepository()
    let useCase = FetchPostsUseCaseImpl(repository: repository)
    let viewModel = FeedViewModel(fetchPostsUseCase: useCase)
    let cacheService = MediaCacheService()
    let playbackService = VideoPlaybackService(cacheService: cacheService)
    return FeedView(viewModel: viewModel, cacheService: cacheService, playbackService: playbackService)
}

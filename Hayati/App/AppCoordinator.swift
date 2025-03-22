//
//  AppCoordinator.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
//
import SwiftUI

class AppCoordinator {
    func start() -> some View {
        let repository = LocalPostRepository()
        let useCase = FetchPostsUseCaseImpl(repository: repository)
        let viewModel = FeedViewModel(fetchPostsUseCase: useCase)
        let cacheService = MediaCacheService()
        let playbackService = VideoPlaybackService()
        return FeedView(viewModel: viewModel, cacheService: cacheService, playbackService: playbackService)
    }
}

//
//  AppCoordinator.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
//
import SwiftUI

class AppCoordinator {
    func start() -> some View {
        let networkService = NetworkServiceImpl()
        let cacheService = CacheServiceImpl()
        let repository = ImgurPostRepository(networkService: networkService, cacheService: cacheService)
        let useCase = FetchPostsUseCaseImpl(repository: repository)
        let viewModel = FeedViewModel(fetchPostsUseCase: useCase)
        let mediaCacheService = MediaCacheService()
        let playbackService = VideoPlaybackService(cacheService: mediaCacheService)
        return FeedView(viewModel: viewModel, cacheService: mediaCacheService, playbackService: playbackService)
    }
}

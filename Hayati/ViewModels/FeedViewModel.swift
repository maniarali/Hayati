//
//  FeedViewModel.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
//
import Combine
import SwiftUI

class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoadingInitial = true
    @Published var isLoadingMore = false
    private let fetchPostsUseCase: FetchPostsUseCase
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 0
    
    init(fetchPostsUseCase: FetchPostsUseCase) {
        self.fetchPostsUseCase = fetchPostsUseCase
        fetchInitialPosts()
    }
    
    private func fetchInitialPosts() {
        fetchPostsUseCase.execute(page: currentPage)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Initial fetch error: \(error)")
                }
                self?.isLoadingInitial = false
            }, receiveValue: { [weak self] newPosts in
                self?.posts = newPosts
                self?.currentPage += 1
            })
            .store(in: &cancellables)
    }
    
    func loadMorePostsIfNeeded(currentIndex: Int) {
        let threshold = posts.count / 2
        guard !isLoadingMore, currentIndex >= threshold else { return }
        isLoadingMore = true
        fetchPostsUseCase.execute(page: currentPage)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoadingMore = false
                if case .failure(let error) = completion {
                    print("More posts error: \(error)")
                }
            }, receiveValue: { [weak self] newPosts in
                self?.posts.append(contentsOf: newPosts)
                self?.currentPage += 1
            })
            .store(in: &cancellables)
    }
}

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
    private let fetchPostsUseCase: FetchPostsUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(fetchPostsUseCase: FetchPostsUseCase) {
        self.fetchPostsUseCase = fetchPostsUseCase
        loadPosts()
    }
    
    func loadPosts() {
        fetchPostsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching posts: \(error)")
                }
            }, receiveValue: { [weak self] posts in
                self?.posts = posts
            })
            .store(in: &cancellables)
    }
}

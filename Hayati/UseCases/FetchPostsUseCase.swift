//
//  FetchPostsUseCase.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
//
import Combine

protocol FetchPostsUseCase {
    func execute(page: Int) -> AnyPublisher<[Post], Error>
}

class FetchPostsUseCaseImpl: FetchPostsUseCase {
    private let repository: PostRepository
    
    init(repository: PostRepository) {
        self.repository = repository
    }
    
    func execute(page: Int) -> AnyPublisher<[Post], Error> {
        repository.fetchPosts(page: page)
    }
}

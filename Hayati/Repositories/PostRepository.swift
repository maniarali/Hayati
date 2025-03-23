//
//  PostRepository.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
//

import Combine

protocol PostRepository {
    func fetchPosts(page: Int) -> AnyPublisher<[Post], Error>
}

//
//  ImgurPostRepository.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
//
import Foundation
import Combine

class ImgurPostRepository: PostRepository {
    private let networkService: NetworkService
    private let cacheService: CacheService
    
    init(networkService: NetworkService = NetworkServiceImpl(), cacheService: CacheService = CacheServiceImpl()) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    func fetchPosts(page: Int) -> AnyPublisher<[Post], Error> {
        if let cachedPosts = cacheService.loadPosts(forPage: page) {
            return Just(cachedPosts)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        let urlString = "\(Config.baseURL)/\(Config.version)/\(Config.category)/\(Config.section)/\(Config.sort)/\(Config.window)/\(page)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let headers = ["Authorization": "Client-ID \(Config.imgurClientID)"]
        
        return networkService.fetchData(from: url, headers: headers)
            .map { (response: ImgurResponse) -> [Post] in
                response.data.compactMap { item in
                    guard let media = item.images?.first,
                          let url = URL(string: media.link) else { return nil }
                    let type: MediaType = media.type == "video/mp4" ? .video : .photo
                    return Post(id: item.id, media: Media(type: type, url: url))
                }
            }
            .handleEvents(receiveOutput: { [weak self] posts in
                self?.cacheService.savePosts(posts, forPage: page)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

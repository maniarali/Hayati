//
//  ImgurPostRepository.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
//
import Foundation
import Combine

class ImgurPostRepository: PostRepository {
    private let clientID = "Client-ID"
    private let cache = NSCache<NSString, NSArray>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("PostsCache")
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    func fetchPosts(page: Int) -> AnyPublisher<[Post], Error> {
        if let cachedPosts = loadFromCache(page: page) {
            return Just(cachedPosts)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        let url = URL(string: "https://api.imgur.com/3/gallery/hot/viral/day/\(page)")!
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: ImgurResponse.self, decoder: JSONDecoder())
            .map { response -> [Post] in
                response.data.compactMap { item -> Post? in
                    guard let media = item.images?.first,
                          let url = URL(string: media.link) else { return nil }
                    let type: MediaType = media.type == "video/mp4" ? .video : .photo
                    return Post(id: item.id, media: Media(type: type, url: url))
                }
            }
            .handleEvents(receiveOutput: { [weak self] posts in
                self?.saveToCache(posts: posts, page: page)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func saveToCache(posts: [Post], page: Int) {
        cache.setObject(posts as NSArray, forKey: "page_\(page)" as NSString)
        let fileURL = cacheDirectory.appendingPathComponent("page_\(page).json")
        if let data = try? JSONEncoder().encode(posts) {
            try? data.write(to: fileURL)
        }
    }
    
    private func loadFromCache(page: Int) -> [Post]? {
        if let cached = cache.object(forKey: "page_\(page)" as NSString) as? [Post] {
            return cached
        }
        let fileURL = cacheDirectory.appendingPathComponent("page_\(page).json")
        if let data = try? Data(contentsOf: fileURL),
           let posts = try? JSONDecoder().decode([Post].self, from: data) {
            cache.setObject(posts as NSArray, forKey: "page_\(page)" as NSString)
            return posts
        }
        return nil
    }
}

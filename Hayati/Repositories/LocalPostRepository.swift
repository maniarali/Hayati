//
//  LocalPostRepository.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
//
import Foundation
import Combine

class LocalPostRepository: PostRepository {
    init() {
        let urls = [
            Bundle.main.url(forResource: "photo1", withExtension: "jpg"),
            Bundle.main.url(forResource: "video1", withExtension: "mp4"),
            Bundle.main.url(forResource: "photo2", withExtension: "jpg"),
            Bundle.main.url(forResource: "video2", withExtension: "mp4")
        ]
        urls.forEach { url in print("Asset \(url?.lastPathComponent ?? "nil") exists: \(url != nil)") }
    }
    
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        let posts = [
            Post(media: [Media(type: .photo, url: Bundle.main.url(forResource: "photo1", withExtension: "jpg")!)], caption: ""),
            Post(media: [Media(type: .video, url: Bundle.main.url(forResource: "video1", withExtension: "mp4")!)], caption: ""),
            Post(media: [
                Media(type: .photo, url: Bundle.main.url(forResource: "photo2", withExtension: "jpg")!),
                Media(type: .video, url: Bundle.main.url(forResource: "video2", withExtension: "mp4")!)
            ], caption: "")
        ]
        return Just(posts)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

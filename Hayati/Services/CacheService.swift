//
//  CacheService.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
//
import Foundation
import Combine

protocol CacheService {
    func savePosts(_ posts: [Post], forPage page: Int)
    func loadPosts(forPage page: Int) -> [Post]?
}

class CacheServiceImpl: CacheService {
    private let cache = NSCache<NSString, NSArray>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("PostsCache")
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    func savePosts(_ posts: [Post], forPage page: Int) {
        let key = "page_\(page)" as NSString
        cache.setObject(posts as NSArray, forKey: key)
        let fileURL = cacheDirectory.appendingPathComponent("\(key).json")
        if let data = try? JSONEncoder().encode(posts) {
            try? data.write(to: fileURL)
        }
    }
    
    func loadPosts(forPage page: Int) -> [Post]? {
        let key = "page_\(page)" as NSString
        if let cached = cache.object(forKey: key) as? [Post] {
            return cached
        }
        let fileURL = cacheDirectory.appendingPathComponent("\(key).json")
        if let data = try? Data(contentsOf: fileURL),
           let posts = try? JSONDecoder().decode([Post].self, from: data) {
            cache.setObject(posts as NSArray, forKey: key)
            return posts
        }
        return nil
    }
}

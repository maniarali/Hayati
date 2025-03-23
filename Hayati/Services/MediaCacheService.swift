//
//  MediaCacheService.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
//
import Foundation
import UIKit

class MediaCacheService {
    private let imageCache = NSCache<NSString, UIImage>()
    private let videoCache = NSCache<NSString, NSData>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("MediaCache")
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        imageCache.totalCostLimit = 100 * 1024 * 1024 // 100 MB
        videoCache.totalCostLimit = 500 * 1024 * 1024 // 500 MB
    }
    
    func loadImage(from url: URL) async throws -> UIImage? {
        let cacheKeyStr = url.absoluteString
        let cacheKey = url.absoluteString as NSString
        
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            return cachedImage
        }
        let fileURL = cacheDirectory.appendingPathComponent(cacheKeyStr.sha256())
        if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
            imageCache.setObject(image, forKey: cacheKey, cost: data.count)
            return image
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else { throw CacheError.invalidData }
        imageCache.setObject(image, forKey: cacheKey, cost: data.count)
        try? data.write(to: fileURL)
        return image
    }
    
    func loadVideo(from url: URL) async throws -> URL {
        let cacheKeyStr = url.absoluteString
        let cacheKey = cacheKeyStr as NSString
        if let cachedVideoData = videoCache.object(forKey: cacheKey) {
            let tempURL = cacheDirectory.appendingPathComponent("\(cacheKeyStr.sha256()).mp4")
            try? cachedVideoData.write(to: tempURL)
            return tempURL
        }
        let fileURL = cacheDirectory.appendingPathComponent("\(cacheKeyStr.sha256()).mp4")
        if fileManager.fileExists(atPath: fileURL.path) {
            let data = try Data(contentsOf: fileURL)
            videoCache.setObject(data as NSData, forKey: cacheKey, cost: data.count)
            return fileURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        try data.write(to: fileURL)
        videoCache.setObject(data as NSData, forKey: cacheKey, cost: data.count)
        return fileURL
    }
}

enum CacheError: Error {
    case invalidData
}

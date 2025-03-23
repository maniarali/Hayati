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
        imageCache.totalCostLimit = 100 * 1024 * 1024 // 100 MB for images
        videoCache.totalCostLimit = 500 * 1024 * 1024 // 500 MB for videos
    }
    
    func loadImage(from url: URL) async throws -> UIImage? {
        let cacheKey = url.absoluteString
        let nsCacheKey = cacheKey as NSString
        
        // Check in-memory cache
        if let cachedImage = imageCache.object(forKey: nsCacheKey) {
            return cachedImage
        }
        
        // Check disk cache
        let fileURL = cacheDirectory.appendingPathComponent(cacheKey.sha256())
        if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
            imageCache.setObject(image, forKey: nsCacheKey, cost: data.count)
            return image
        }
        
        // Fetch from network
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else { throw CacheError.invalidData }
        imageCache.setObject(image, forKey: nsCacheKey, cost: data.count)
        try? data.write(to: fileURL) // Save to disk
        return image
    }
    
    func loadVideo(from url: URL) async throws -> URL {
        let cacheKey = url.absoluteString
        let nsCacheKey = cacheKey as NSString
        
        // Check in-memory cache
        if let cachedVideoData = videoCache.object(forKey: nsCacheKey) {
            let tempURL = cacheDirectory.appendingPathComponent("\(cacheKey.sha256()).mp4")
            try? cachedVideoData.write(to: tempURL)
            return tempURL
        }
        
        // Check disk cache
        let fileURL = cacheDirectory.appendingPathComponent("\(cacheKey.sha256()).mp4")
        if fileManager.fileExists(atPath: fileURL.path) {
            let data = try Data(contentsOf: fileURL)
            videoCache.setObject(data as NSData, forKey: nsCacheKey, cost: data.count)
            return fileURL
        }
        
        // Fetch from network
        let (data, _) = try await URLSession.shared.data(from: url)
        try data.write(to: fileURL) // Save to disk
        videoCache.setObject(data as NSData, forKey: nsCacheKey, cost: data.count)
        return fileURL
    }
    
    func clearCache() {
        imageCache.removeAllObjects()
        videoCache.removeAllObjects()
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        print("Cleared media cache")
    }
}

enum CacheError: Error {
    case invalidData
}

// Extension to generate SHA-256 hash for safe filenames
extension String {
    func sha256() -> String {
        guard let data = data(using: .utf8) else { return self }
        return data.sha256().map { String(format: "%02x", $0) }.joined()
    }
}

extension Data {
    func sha256() -> [UInt8] {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(count), &hash)
        }
        return hash
    }
}

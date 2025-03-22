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
    
    func cachedImage(for url: URL) -> UIImage? {
        imageCache.object(forKey: url.absoluteString as NSString)
    }
    
    func cacheImage(_ image: UIImage, for url: URL) {
        imageCache.setObject(image, forKey: url.absoluteString as NSString)
    }
    
    func loadImage(from url: URL) async throws -> UIImage {
        if let cached = cachedImage(for: url) {
            return cached
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else { throw URLError(.badServerResponse) }
        cacheImage(image, for: url)
        return image
    }
}

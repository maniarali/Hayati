//
//  VideoPlaybackService.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
//
import AVKit
import Foundation

class VideoPlaybackService {
    private var players: [String: AVPlayer] = [:]
    private let cacheService: MediaCacheService
    
    init(cacheService: MediaCacheService) {
        self.cacheService = cacheService
    }
    
    func player(for post: Post) async -> AVPlayer? {
        guard post.media.type == .video else { return nil }
        if let existingPlayer = players[post.id] {
            await existingPlayer.seek(to: .zero)
            return existingPlayer
        }
        
        do {
            let localURL = try await cacheService.loadVideo(from: post.media.url)
            let player = AVPlayer(url: localURL)
            players[post.id] = player
            print("Created player for \(post.id): \(localURL.lastPathComponent)")
            return player
        } catch {
            print("Failed to load video for \(post.id): \(error)")
            return nil
        }
    }
    
    func play(_ player: AVPlayer) {
        player.seek(to: .zero)
        player.playImmediately(atRate: 1.0)
        print("Playing \(player.currentItem?.asset ?? nil)")
    }
    
    func pause(_ player: AVPlayer) {
        player.pause()
        print("Paused \(player.currentItem?.asset ?? nil)")
    }
    
    func cleanup() {
        players.values.forEach { $0.pause() }
        players.removeAll()
        print("Cleaned up all players")
    }
}

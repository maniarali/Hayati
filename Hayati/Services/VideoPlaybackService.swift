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
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 30
        self.session = URLSession(configuration: config)
    }
    
    func player(for post: Post) -> AVPlayer? {
        guard post.media.type == .video else { return nil }
        if let existingPlayer = players[post.id] {
            existingPlayer.seek(to: .zero)
            return existingPlayer
        }
        let playerItem = AVPlayerItem(url: post.media.url)
        let player = AVPlayer(playerItem: playerItem)
        player.isMuted = true
        players[post.id] = player
        preload(player, url: post.media.url)
        print("Created player for \(post.id): \(post.media.url.lastPathComponent)")
        return player
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
    
    private func preload(_ player: AVPlayer, url: URL) {
        Task(priority: .high) {
            do {
                let isPlayable = try await player.currentItem?.asset.load(.isPlayable) ?? false
                if isPlayable {
                    print("Preloaded \(url)")
                } else {
                    print("Asset not playable: \(url)")
                    players.removeValue(forKey: url.lastPathComponent)
                }
            } catch {
                print("Preload error for \(url): \(error)")
                players.removeValue(forKey: url.lastPathComponent)
            }
        }
    }
    
    func cleanup() {
        players.values.forEach { $0.pause() }
        players.removeAll()
        print("Cleaned up all players")
    }
}

//
//  VideoPlaybackService.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
//
import AVKit

class VideoPlaybackService {
    private var players: [URL: AVPlayer] = [:]
    
    func player(for mediaURL: URL) -> AVPlayer {
        if let existingPlayer = players[mediaURL] {
            return existingPlayer
        }
        let player = AVPlayer(url: mediaURL)
        player.isMuted = true
        players[mediaURL] = player
        print("Created player for \(mediaURL.lastPathComponent)")
        return player
    }
    
    func removePlayer(for mediaURL: URL) {
        players.removeValue(forKey: mediaURL)
        print("Removed player for \(mediaURL.lastPathComponent)")
    }
}

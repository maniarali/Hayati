//
//  MediaItem.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 22/03/2025.
//
import Foundation

enum MediaType {
    case photo
    case video
}

struct Media {
    let type: MediaType
    let url: URL
}

struct Post: Identifiable {
    let id: UUID = UUID()
    let media: [Media]
    let caption: String
}

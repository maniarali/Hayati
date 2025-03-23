//
//  MediaItem.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 22/03/2025.
//
import Foundation

enum MediaType: String, Codable {
    case photo
    case video
}

struct Media: Codable {
    let type: MediaType
    let url: URL
}

struct Post: Identifiable, Codable {
    let id: String
    let media: Media
}

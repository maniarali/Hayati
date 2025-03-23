//
//  ImgurModels.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
//
import Foundation

struct ImgurResponse: Codable {
    let data: [ImgurItem]
}

struct ImgurItem: Codable {
    let id: String
    let images: [ImgurImage]?
}

struct ImgurImage: Codable {
    let link: String
    let type: String
}

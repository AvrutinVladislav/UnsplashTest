//
//  Photo.swift
//  UnsplashTestApp
//
//  Created by Vladislav Avrutin on 15.09.2024.
//

import Foundation

struct PhotoCell: Codable {
    let photo: Photo
    var isFavorite = false
}

struct Photo: Codable {
    let id: String
    let created_at: String
    let downloads: Int?
    let urls: URLs
    let user: User
    let location: Location?
}

struct URLs: Codable {
    let small: String
    let full: String
}

struct User: Codable {
    let name: String
}

struct Location: Codable {
    let name: String?
}

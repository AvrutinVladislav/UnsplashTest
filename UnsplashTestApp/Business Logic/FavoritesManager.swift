//
//  FavoritesManager.swift
//  UnsplashTestApp
//
//  Created by Vladislav Avrutin on 15.09.2024.
//

import Foundation


final class FavoritesManager {
    static let shared = FavoritesManager()
    
    private(set) var favorites: [PhotoCell] = []
    
    func add(_ item: PhotoCell) {
        favorites.append(item)
    }
    
    func remove(_ item: PhotoCell) {
        favorites.removeAll { $0.photo.id == item.photo.id }
    }
    
}


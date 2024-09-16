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
        if favorites.contains(where: {$0.photo.id != item.photo.id}) || favorites.isEmpty {
            favorites.append(item)
        }        
        saveToUserDefaults(favorites)
    }
    
    func remove(_ item: PhotoCell) {
        favorites.removeAll { $0.photo.id == item.photo.id }
        saveToUserDefaults(favorites)
    }
    
    func saveToUserDefaults(_ objects: [PhotoCell]) {
          let encoder = JSONEncoder()
          if let encoded = try? encoder.encode(objects){
             UserDefaults.standard.set(encoded, forKey: "FavoriteImages")
          }
     }
    
    func loadFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: "FavoriteImages") else { return }
        do {
            favorites = try JSONDecoder().decode([PhotoCell].self, from: data)
        }
        catch {
            print("Error load data from UserDefault")
        }
    }
    
}


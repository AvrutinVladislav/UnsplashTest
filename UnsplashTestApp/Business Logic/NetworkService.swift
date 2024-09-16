//
//  NetworkService.swift
//  UnsplashTestApp
//
//  Created by Vladislav Avrutin on 15.09.2024.
//

import Foundation

final class NetworkService {
    
    static let shared = NetworkService()
    private let apiKey = "GddY2QVUvEZhiOqkmTMs9j2KFfGh7E5kNjUzOiN46EY"
    
    private init() {}
    
    func fetchRandomPhotos(query: String = "") async throws -> [Photo] {
        let urlString = query.isEmpty ? "https://api.unsplash.com/photos/random/?count=30&client_id=\(apiKey)"
                                      : "https://api.unsplash.com/search/photos?query=\(query)&client_id=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        if query.isEmpty {
            return try decoder.decode([Photo].self, from: data)
        } else {
            let searchResults = try decoder.decode(SearchResults.self, from: data)
            return searchResults.results
        }
    }
    
}

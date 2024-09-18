//
//  NetworkService.swift
//  UnsplashTestApp
//
//  Created by Vladislav Avrutin on 15.09.2024.
//

import Foundation

final class NetworkService {
    
    static let shared = NetworkService()
    private let baseUrl = "https://api.unsplash.com/photos"
    private let apiKey = "GddY2QVUvEZhiOqkmTMs9j2KFfGh7E5kNjUzOiN46EY"
    
    private init() {}
    
    func fetchRandomPhotos(query: String = "", page: Int, perPage: Int) async throws -> [Photo] {
        guard var urlComponents = URLComponents(string: baseUrl)
        else { throw URLError(.badURL) }
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: page.description),
            URLQueryItem(name: "per_page", value: perPage.description),
            URLQueryItem(name: "client_id", value: apiKey),
        ]
        guard let url = urlComponents.url else { throw URLError(.badURL) }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        if query.isEmpty {
            return try decoder.decode([Photo].self, from: data)
        } else {
            return try decoder.decode(SearchResults.self, from: data).results
        }
    }
}

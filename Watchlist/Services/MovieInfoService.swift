//
//  MovieInfoService.swift
//  Watchlist
//
//  Created by Kaloyan Dimov on 2.03.22.
//

import Foundation

struct Endpoint {
    let path: String
    let query: String?
}

extension Endpoint {
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3".appending(path)
        components.fragment = nil
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "region", value: "US"),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "api_key", value: "YOUR_API_KEY_HERE")
        ]
        
        return components.url
    }
    
}

extension Endpoint {
    
    static func nowPlaying() -> Endpoint {
        return Endpoint(path: "/movie/now_playing", query: nil)
    }
    
    static func popular() -> Endpoint {
        return Endpoint(path: "/movie/popular", query: nil)
    }
    
    static func topRated() -> Endpoint {
        return Endpoint(path: "/movie/top_rated", query: nil)
    }
    
    static func upcoming() -> Endpoint {
        return Endpoint(path: "/movie/upcoming", query: nil)
    }
    
    static func movie(matching query: String) -> Endpoint {
        return Endpoint(path: "/search/movie", query: query)
    }
    
    static func movie(id: Int) -> Endpoint {
        return Endpoint(path: "/movie/\(id)", query: nil)
    }
    
}

struct MovieResponse: Decodable {
    let results: [Movie]
}

enum MovieError: String, Error {
    case apiError =
            "Failed to fetch data"
    case invalidURL =
            "Invalid endpoint"
    case invalidResponse =
            "Invalid response"
    case invalidData =
            "Invalid data"
    case deserializationError =
            "Failed to decode data"
}

class MovieInfoService {
    
    static let shared = MovieInfoService()
    
    private let urlSession = URLSession.shared
    private let jsonDecoder = customJSONDecoder()
    
    private init() { }
    
    func request<D: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<D, MovieError>) -> ()) {
        guard let url = endpoint.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        urlSession.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if error != nil {
                completion(.failure(.apiError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decodedData = try self.jsonDecoder.decode(D.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.deserializationError))
            }
            
        }.resume()
    }
    
    private static func customJSONDecoder() -> JSONDecoder {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return jsonDecoder
    }
    
}


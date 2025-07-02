//
//  MovieService.swift
//  Watchlist
//
//  Created by Kaloyan Dimov on 2.07.25.
//

import Foundation

enum MovieEndpoint: Endpoint {
    case nowPlaying
    case popular
    case topRated
    case upcoming
    case movie(Int)
    case search(String)
    
    var name: String {
        switch self {
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular"
        case .topRated:
            return "Top Rated"
        case .upcoming:
            return "Upcoming"
        case .movie:
            return "Movie"
        case .search:
            return "Search"
        }
    }
    
    var path: String? {
        switch self {
        case .nowPlaying:
            return "/movie/now_playing"
        case .popular:
            return "/movie/popular"
        case .topRated:
            return "/movie/top_rated"
        case .upcoming:
            return "/movie/upcoming"
        case .movie(let id):
            return "/movie/\(id)"
        case .search:
            return "/search/movie"
        }
    }
    
    var query: String? {
        switch self {
        case .nowPlaying, .popular, .topRated, .upcoming, .movie:
            return nil
        case .search(let query):
            return query
        }
    }
    
    var request: URLRequest? {
        guard let url = url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer ACCESS_TOKEN"
        ]
        
        return request
    }
    
    var url: URL? {
        guard let path = path else { return nil }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3" + path
        components.fragment = nil
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "region", value: "US"),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "include_adult", value: "false"),
        ]
        
        return components.url
    }
}

enum MovieError: String, Error {
    case apiError = "Failed to fetch data"
    case deserializationError = "Failed to decode data"
    case invalidData = "Invalid data"
    case invalidResponse = "Invalid response"
    case invalidURL = "Invalid URL"
}

struct MovieResponse: Decodable {
    let results: [Movie]
}

class MovieService {
    static let shared = MovieService()
    
    private lazy var jsonDecoder = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return jsonDecoder
    }()
    
    private init() { }
    
    func request<D: Decodable>(_ endpoint: MovieEndpoint, completion: @escaping (Result<D, MovieError>) -> ()) {
        guard let request = endpoint.request else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.apiError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let movies = try self.jsonDecoder.decode(D.self, from: data)
                
                completion(.success(movies))
            } catch {
                completion(.failure(.deserializationError))
            }
        }.resume()
    }
}

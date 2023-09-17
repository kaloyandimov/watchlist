//
//  ImageService.swift
//  Watchlist
//
//  Created by Kaloyan Dimov on 3.03.22.
//

import UIKit

enum ImageEndpoint: Endpoint {
    case poster(String?)
    case backdrop(String?)
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "image.tmdb.org"
        components.path = "/t/p/original".appending(path ?? "")
        components.fragment = nil
        
        return components.url
    }
    
    var path: String? {
        switch self {
        case .poster(let path):
            return path
        case .backdrop(let path):
            return path
        }
    }
    
    var query: String? {
        return nil
    }
}

enum ImageError: String, Error {
    case apiError = "Failed to load image"
    case invalidData = "Invalid image data"
    case invalidPath = "Invalid image path"
    case invalidResponse = "Invalid response"
    case invalidURL = "Invalid image URL"
}

class ImageService {
    static let shared = ImageService()
    
    private let cache = ImageCache()
    
    private var requests = [UUID : URLSessionTask]()
    
    private init() { }
    
    func request(_ endpoint: ImageEndpoint, completion: @escaping (Result<UIImage, ImageError>) -> ()) -> UUID? {
        guard let path = endpoint.path else {
            completion(.failure(.invalidPath))
            return nil
        }
        
        if let image = cache.get(for: path) {
            completion(.success(image))
            return nil
        }
        
        guard let url = endpoint.url else {
            completion(.failure(.invalidURL))
            return nil
        }
        
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.apiError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(.invalidData))
                return
            }
            
            self.cache.set(image, for: path)
            
            completion(.success(image))
        }
        
        requests[uuid] = task
        
        task.resume()
        
        return uuid
    }
    
    func cancelRequest(_ uuid: UUID?) {
        if let uuid = uuid {
            requests[uuid]?.cancel()
            requests.removeValue(forKey: uuid)
        }
    }
}

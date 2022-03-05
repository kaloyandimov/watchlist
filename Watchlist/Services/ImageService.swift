//
//  ImageService.swift
//  Watchlist
//
//  Created by Kaloyan Dimov on 3.03.22.
//

import Foundation

extension Endpoint {
    var imageURL: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "image.tmdb.org"
        components.path = "/t/p/w500".appending(path!)
        components.fragment = nil
        
        return components.url
    }
}

extension Endpoint {
    static func backdrop(path: String) -> Endpoint {
        return Endpoint(path: path, query: nil)
    }
    
    static func poster(path: String) -> Endpoint {
        return Endpoint(path: path, query: nil)
    }
}

enum ImageError: String, Error {
    case apiError =
            "Failed to load image"
    case emptyPath =
            "Empty path"
    case invalidImageURL =
            "Invalid image URL"
    case invalidResponse =
            "Invalid response"
    case invalidImageData =
            "Invalid image data"
}

class ImageService {
    static let shared = ImageService()
    
    private let fileManager = FileManager.default
    private let urlSession = URLSession.shared
    private let cacheURL: URL
    
    private init() {
        self.cacheURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    func request(_ endpoint: Endpoint, completion: @escaping (Result<Data, ImageError>) -> ()) {
        guard let path = endpoint.path else {
            completion(.failure(.emptyPath))
            return
        }
        
        let dstURL = cacheURL.appendingPathComponent(String(path))
        
        if fileManager.fileExists(atPath: dstURL.path) {
            let data = try! Data(contentsOf: dstURL)
            completion(.success(data))
            return
        }
        
        urlSession.downloadTask(with: endpoint.imageURL!) { (srcURL, response, error) in
            if error != nil {
                completion(.failure(.apiError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let srcURL = srcURL else {
                completion(.failure(.invalidImageURL))
                return
            }
            
            guard let data = try? Data(contentsOf: srcURL) else {
                completion(.failure(.invalidImageURL))
                return
            }
            
            try? self.fileManager.moveItem(at: srcURL, to: dstURL)
            completion(.success(data))
            
        }.resume()
    }
}


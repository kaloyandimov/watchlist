//
//  ImageCache.swift
//  Watchlist
//
//  Created by Kaloyan Dimov on 14.09.23.
//

import UIKit

struct ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    
    func set(_ value: UIImage, for key: String) {
        cache.setObject(value, forKey: key as NSString)
    }
    
    func get(for key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func remove(for key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func removeAll() {
        cache.removeAllObjects()
    }
}

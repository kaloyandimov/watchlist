//
//  Endpoint.swift
//  Watchlist
//
//  Created by Kaloyan Dimov on 3.03.22.
//

import Foundation

protocol Endpoint {
    var url: URL? { get }
    var path: String? { get }
    var query: String? { get }
}

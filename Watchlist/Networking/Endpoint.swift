//
//  Endpoint.swift
//  Watchlist
//
//  Created by Kaloyan Dimov on 2.07.25.
//

import Foundation

protocol Endpoint {
    var url: URL? { get }
    var path: String? { get }
    var query: String? { get }
}

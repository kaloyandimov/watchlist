//
//  SearchViewController.swift
//  Watchlist
//
//  Created by Kaloyan Dimov on 6.03.22.
//

import UIKit

class SearchViewController: UITableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    
    var results = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 8
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        
        cell.configure(movie: results[indexPath.row])
        
        return cell
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            return
        }
        
        MovieInfoService.shared.request(.movie(matching: text)) { [weak self] (result: Result<MovieResponse, MovieError>) in
            switch result {
            case .success(let success):
                self?.results = success.results
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    print(failure.rawValue)
                }
            }
        }
    }
}

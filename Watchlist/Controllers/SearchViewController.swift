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
        
        let nib = UINib(nibName: "SearchCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "searchCell")
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Movies"
        searchController.searchBar.autocapitalizationType = .none
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchCell
        
        cell.configure(for: results[indexPath.row])
        
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        
        results.removeAll()
        
        tableView.reloadData()
    }
}

// MARK: - Search results updating

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let title = searchController.searchBar.text, !title.isEmpty else {
            return
        }
        
        MovieService.shared.request(.search(title)) { [weak self] (result: Result<MovieResponse, MovieError>) in
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

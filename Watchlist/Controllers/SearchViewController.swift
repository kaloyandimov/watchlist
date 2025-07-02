//
//  SearchViewController.swift
//  Watchlist
//
//  Created by Kaloyan Dimov on 1.07.25.
//

import UIKit

class SearchViewController: UIViewController {
    private var searchTask: DispatchWorkItem?
    private var searchResults: [Movie] = []
    
    private lazy var tableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = UITableView.automaticDimension
        tv.keyboardDismissMode = .onDrag
        tv.dataSource = self
        tv.register(SearchCell.self, forCellReuseIdentifier: SearchCell.reuseIdentifier)
        
        return tv
    }()
    
    private lazy var searchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.autocapitalizationType = .none
        sc.searchBar.placeholder = "Search Movies"
        sc.searchResultsUpdater = self
        
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        definesPresentationContext = true
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

// MARK: - Table view data source

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.reuseIdentifier, for: indexPath) as? SearchCell else {
            fatalError("SearchCell")
        }
        
        cell.configure(with: searchResults[indexPath.row])
        
        return cell
    }
}

// MARK: - Search results updating

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchTask?.cancel()
        
        guard let title = searchController.searchBar.text, !title.isEmpty else {
            searchResults.removeAll()
            tableView.reloadData()
            return
        }
        
        let task = DispatchWorkItem { [weak self] in
            MovieService.shared.request(.search(title)) { (result: Result<MovieResponse, MovieError>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self?.searchResults = response.results
                        self?.tableView.setContentOffset(.zero, animated: false)
                        self?.tableView.reloadData()
                    case .failure(let error):
                        print("Search error: \(error)")
                    }
                }
            }
        }
        
        searchTask = task
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
    }
}

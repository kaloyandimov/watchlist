//
//  FeaturedViewController.swift
//  Watchlist
//
//  Created by Kaloyan Dimov on 12.09.23.
//

import UIKit

class FeaturedViewController: UITableViewController {
    let sections: [MovieEndpoint] = [.nowPlaying, .popular, .topRated, .upcoming]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CarouselCell.nib(), forCellReuseIdentifier: CarouselCell.identifier)
    }
}

// MARK: - UITableViewDelegate

extension FeaturedViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.width / 4 * 16 / 9 + 10
    }
}

// MARK: - UITableViewDataSource

extension FeaturedViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CarouselCell.identifier, for: indexPath)  as! CarouselCell

        cell.configure(for: sections[indexPath.section])

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }
}

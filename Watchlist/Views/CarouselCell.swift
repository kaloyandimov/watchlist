//
//  CarouselCell.swift
//  Watchlist
//
//  Created by Kaloyan Dimov on 12.09.23.
//

import UIKit

class CarouselCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    static let identifier = "CarouselCell"
    
    var movies = [Movie]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(TileCell.nib(), forCellWithReuseIdentifier: TileCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configure(for endpoint: MovieEndpoint) {
        MovieService.shared.request(endpoint) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.movies = response.results
                    self.collectionView.reloadData()
                }
            case .failure:
                self.movies = []
            }
        }
    }
}

extension CarouselCell: UICollectionViewDelegate {
    
}

extension CarouselCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TileCell.identifier, for: indexPath) as! TileCell
        
        cell.configure(with: movies[indexPath.row])

        return cell
    }
}

extension CarouselCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = contentView.frame.size.width / 4

        return CGSize(width: width, height: width * 16 / 9)
    }
}

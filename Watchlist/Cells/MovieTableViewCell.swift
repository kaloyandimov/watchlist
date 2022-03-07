//
//  MovieTableViewCell.swift
//  Watchlist
//
//  Created by Kaloyan Dimov on 6.03.22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    static let identifier = "movieTableCell"
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
    
    func configure(movie: Movie) {
        titleLabel.text = movie.title
        yearLabel.text = String(movie.releaseDate.prefix(4))
        
        ImageService.shared.request(.poster(path: movie.posterPath)) { [weak self] result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self?.posterImageView.image = UIImage(data: success)
//                    ?.preparingThumbnail(of: CGSize(width: 80, height: 120))
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    print(failure.rawValue)
                }
            }
        }
    }
}

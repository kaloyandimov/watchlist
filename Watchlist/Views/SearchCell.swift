//
//  SearchCell.swift
//  Watchlist
//
//  Created by Kaloyan Dimov on 9.09.23.
//

import UIKit

class SearchCell: UITableViewCell {
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    func configure(for movie: Movie) {
        titleLabel.text = movie.title
        subtitleLabel.text = String(movie.releaseDate.prefix(4))
        
        ImageService.shared.request(.poster(with: movie.posterPath)) { result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.posterImage.image = UIImage(data: success)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.posterImage.image = UIImage(named: "poster")
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImage.image = nil
    }
}

//
//  SearchCell.swift
//  Watchlist
//
//  Created by Kaloyan Dimov on 9.09.23.
//

import Combine
import UIKit

class SearchCell: UITableViewCell {
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var uuid: UUID?
    
    func configure(for movie: Movie) {
        titleLabel.text = movie.title
        subtitleLabel.text = String(movie.releaseDate.prefix(4))
        
        uuid = ImageService.shared.request(.poster(movie.posterPath)) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.posterImage.image = image
                }
            case .failure:
                DispatchQueue.main.async {
                    self.posterImage.image = UIImage(named: "poster")
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImage.image = nil
        
        ImageService.shared.cancelRequest(uuid)
    }
}

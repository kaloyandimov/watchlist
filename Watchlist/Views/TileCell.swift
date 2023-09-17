//
//  TileCell.swift
//  Watchlist
//
//  Created by Kaloyan Dimov on 12.09.23.
//

import UIKit

class TileCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    static let identifier = "TileCell"
    
    var uuid: UUID?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        
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

//
//  TileCell.swift
//  Watchlist
//
//  Created by Kaloyan Dimov on 12.09.23.
//

import UIKit

class TileCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    static let identifier = "TileCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        
        ImageService.shared.request(.poster(with: movie.posterPath)) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(named: "poster")
                }
            }
        }
    }
}

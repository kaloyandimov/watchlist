//
//  SearchCell.swift
//  Watchlist
//
//  Created by Kaloyan Dimov on 2.07.25.
//

import UIKit

class SearchCell: UITableViewCell {
    static let reuseIdentifier = "SearchCell"
    
    private lazy var posterImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 90).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 60).isActive = true
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        return label
    }()
    
    private lazy var subtitleLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private lazy var labelStack = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 2
        
        return stack
    }()
    
    private lazy var cellStack = {
        let stack = UIStackView(arrangedSubviews: [posterImageView, labelStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = 12
        
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        preservesSuperviewLayoutMargins = false
        separatorInset = .zero
        layoutMargins = .zero
        accessoryType = .disclosureIndicator
        selectionStyle = .default
        
        contentView.addSubview(cellStack)
        
        NSLayoutConstraint.activate([
            cellStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            cellStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            cellStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            cellStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        subtitleLabel.text = movie.releaseYear.map { String($0) }
        posterImageView.image = UIImage(named: "poster")
    }
}


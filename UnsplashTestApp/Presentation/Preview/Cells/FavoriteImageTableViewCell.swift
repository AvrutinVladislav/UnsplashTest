//
//  FavoriteImageTableViewCell.swift
//  UnsplashTestApp
//
//  Created by Vladislav Avrutin on 15.09.2024.
//

import Foundation
import UIKit

final class FavoriteImageTableViewCell: UITableViewCell {
    
    static let identifire = "Favorite cell"
    
    private let thumbnailImageView = UIImageView()
    private let authorTextView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(thumbnailImageView)
        
        authorTextView.font = .systemFont(ofSize: 16)
        authorTextView.textColor = .black
        authorTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(authorTextView)

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([            
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 180),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 120),

            authorTextView.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 16),
            authorTextView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            authorTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            authorTextView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func fillCell(with photo: PhotoCell) {
        authorTextView.text = photo.photo.user.name
        if let url = URL(string: photo.photo.urls.small) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.thumbnailImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
}


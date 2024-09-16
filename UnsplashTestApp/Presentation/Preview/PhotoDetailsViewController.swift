//
//  PhotoDetailsViewController.swift
//  UnsplashTestApp
//
//  Created by Vladislav Avrutin on 15.09.2024.
//

import Foundation
import UIKit

final class PhotoDetailsViewController: UIViewController {

    private let imageView = UIImageView()
    private let authorLabel = UILabel()
    private let dateLabel = UILabel()
    private let locationLabel = UILabel()
    private let downloadsLabel = UILabel()
    private let favoriteButton = UIButton()
    
    private var photo: PhotoCell
    
    init(photo: PhotoCell) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure(with: photo)
        navigationController?.navigationBar.tintColor = .black
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        authorLabel.font = .boldSystemFont(ofSize: 18)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.font = .systemFont(ofSize: 16)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        locationLabel.font = .systemFont(ofSize: 16)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        downloadsLabel.font = .systemFont(ofSize: 16)
        downloadsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        favoriteButton.setImage(photo.isFavorite ? UIImage(systemName: "heart.fill")
                                                 : UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .red
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(favoriteButton)
        view.addSubview(downloadsLabel)
        view.addSubview(locationLabel)
        view.addSubview(dateLabel)
        view.addSubview(authorLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 300),
    
            authorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -16),

            dateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            downloadsLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            downloadsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            downloadsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            favoriteButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favoriteButton.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -8),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configure(with item: PhotoCell) {
        if let url = URL(string: item.photo.urls.full) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        authorLabel.text = "Author: \(item.photo.user.name)"
        dateLabel.text = "Date: \(configureDate(for: item.photo.created_at))"
        locationLabel.text = "Location: \(item.photo.location?.name ?? "Unknown")"
        downloadsLabel.text = "Downloads: \(item.photo.downloads ?? 0)"
    }
    
    @objc func toggleFavorite() {
        photo.isFavorite.toggle()
        if photo.isFavorite {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            FavoritesManager.shared.add(photo)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            FavoritesManager.shared.remove(photo)
        }
    }
}

private extension PhotoDetailsViewController {
    func configureDate(for date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        guard let formattedDate = formatter.date(from: date) else { return ""}
        return formatter.string(from: formattedDate)
    }
}

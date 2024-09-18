//
//  FavoriteImagesViewController.swift
//  UnsplashTestApp
//
//  Created by Vladislav Avrutin on 13.09.2024.
//

import Foundation
import UIKit

final class FavoritesViewController: BaseViewController {
    
    private let favoriteTableView = UITableView()
    private let emptyFavoriteListLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteTableView.reloadData()
        emptyFavoriteListLabel.isHidden = !FavoritesManager.shared.favorites.isEmpty
    }
}

private extension FavoritesViewController {
    func setupUI() {
        view.backgroundColor = .white
        favoriteTableView.register(FavoriteImageTableViewCell.self, forCellReuseIdentifier: FavoriteImageTableViewCell.identifire)
        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
        favoriteTableView.selectionFollowsFocus = false
        favoriteTableView.translatesAutoresizingMaskIntoConstraints = false
        favoriteTableView.separatorStyle = .none
        
        emptyFavoriteListLabel.textColor = .black
        emptyFavoriteListLabel.text = "Your favorite list is empty."
        emptyFavoriteListLabel.font = .systemFont(ofSize: 20, weight: .medium)
        emptyFavoriteListLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(favoriteTableView)
        view.addSubview(emptyFavoriteListLabel)
        
        NSLayoutConstraint.activate([
            favoriteTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            favoriteTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            favoriteTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            favoriteTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            emptyFavoriteListLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyFavoriteListLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoritesManager.shared.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteImageTableViewCell.identifire, for: indexPath) as? FavoriteImageTableViewCell {
            let item = FavoritesManager.shared.favorites[indexPath.row]
            cell.fillCell(with: PhotoCell(photo: item.photo))
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = FavoritesManager.shared.favorites[indexPath.row]
        let detailsVC = PhotoDetailsViewController(photo: photo)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

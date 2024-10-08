//
//  RandomPhotosViewController.swift
//  UnsplashTestApp
//
//  Created by Vladislav Avrutin on 13.09.2024.
//

//import Foundation
//import UIKit

import UIKit

final class RandomPhotosViewController: BaseViewController {
    
    private let searchBar = UISearchBar()
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private let notFoundLabel = UILabel()
    private var photos: [PhotoCell] = []
    private var timer: Timer?
    private var paginationPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotos(page: paginationPage)
        setupSearchBar()
        setupCollectionView()
    }
    
}

private extension RandomPhotosViewController {
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search Photos"
        navigationItem.titleView = searchBar
    }
    
    func setupCollectionView() {
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifire)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        notFoundLabel.text = "Image didn't found"
        notFoundLabel.font = .systemFont(ofSize: 25, weight: .medium)
        notFoundLabel.textColor = .black
        notFoundLabel.isHidden = true
        notFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        view.addSubview(notFoundLabel)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            notFoundLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            notFoundLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    func loadPhotos(query: String = "", page: Int) {
        FavoritesManager.shared.loadFromUserDefaults()
        Task {
            do {
                let fetchedPhotos = try await NetworkService.shared.fetchRandomPhotos(query: query, page: page, perPage: 30)
                self.photos.append(contentsOf: prepareData(fetchedPhotos))   
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("Error loading photos: \(error)")
            }
        }
    }
    
    func prepareData(_ fetchData: [Photo]) -> [PhotoCell] {
        var result: [PhotoCell] = []
        fetchData.forEach { item in
            result.append(PhotoCell(photo: item))
        }
        let favoriteImages = FavoritesManager.shared.favorites
        result.forEach { item in
            if let index = favoriteImages.firstIndex(where: {$0.photo.id == item.photo.id}) {
                result[index].isFavorite.toggle()
            }
        }
        return result
    }
    
}

//MARK: - UISearchBarDelegate
extension RandomPhotosViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] timer in
            guard let self else { return }
            self.loadPhotos(query: searchText, page: self.paginationPage)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
    }

}

// MARK: - UICollectionViewDataSource
extension RandomPhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifire, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell()}
        let photo = photos[indexPath.item]
        cell.configure(with: photo)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension RandomPhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        let detailsVC = PhotoDetailsViewController(photo: photo)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension RandomPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 20, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 
    }
}

// MARK: - UIScrollViewDelegate
extension RandomPhotosViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 200 {
            paginationPage += 1
            loadPhotos(page: paginationPage)
        }
    }
}

//
//  ImageCollectionViewCell.swift
//  UnsplashTestApp
//
//  Created by Vladislav Avrutin on 13.09.2024.
//

import SDWebImage
import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    
    static let identifire = "Collection cell"
    
    let imageView = UIImageView()
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           setupUI()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       func configure(with item: PhotoCell) {
           if let url = URL(string: item.photo.urls.small) {
               //Оставляю специально закоменченым нативный вариант загрузки картинки
//               URLSession.shared.dataTask(with: url) { data, response, error in
//                   if let data = data {
//                       DispatchQueue.main.async {
//                           self.imageView.image = UIImage(data: data)
//                       }
//                   }
//               }.resume()
               let spiner = UIActivityIndicatorView(style: .large)
               spiner.translatesAutoresizingMaskIntoConstraints = false
               imageView.addSubview(spiner)
               spiner.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
               spiner.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
               spiner.hidesWhenStopped = true
               self.imageView.sd_setImage(with: url) {_,_,_,_ in
                   if let image = self.imageView.image {
                       spiner.stopAnimating()
                       self.imageView.image = image
                   }
               }
               self.imageView.sd_setImage(with: url, placeholderImage: nil)
           }
       }
}

private extension ImageCollectionViewCell {
    func setupUI() {
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}

//
//  ImageCollectionViewCell.swift
//  UnsplashTestApp
//
//  Created by Vladislav Avrutin on 13.09.2024.
//

import Foundation
import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    
    static let identifire = "Collection cell"
    
    let imageView = UIImageView()
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           contentView.addSubview(imageView)
           imageView.frame = contentView.bounds
           imageView.contentMode = .scaleAspectFill
           imageView.clipsToBounds = true
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       func configure(with item: PhotoCell) {
           if let url = URL(string: item.photo.urls.small) {
               URLSession.shared.dataTask(with: url) { data, response, error in
                   if let data = data {
                       DispatchQueue.main.async {
                           self.imageView.image = UIImage(data: data)
                       }
                   }
               }.resume()
           }
       }
}

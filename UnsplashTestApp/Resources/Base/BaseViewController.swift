//
//  BaseViewController.swift
//  UnsplashTestApp
//
//  Created by Vladislav Avrutin on 18.09.2024.
//

import UIKit

class BaseViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func createLoadSpiner(at view: UIView) -> UIActivityIndicatorView {
        let spiner = UIActivityIndicatorView(style: .large)
        spiner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spiner)
        spiner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spiner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spiner.color = .red
        spiner.hidesWhenStopped = true
        return spiner
    }
}

private extension BaseViewController {
    func configure() {
        view.backgroundColor = Resources.Colors.viewBackground
    }
}

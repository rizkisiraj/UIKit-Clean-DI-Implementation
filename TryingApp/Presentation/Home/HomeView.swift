//
//  HomeView.swift
//  TryingApp
//
//  Created by Rizki Siraj on 31/01/26.
//

import UIKit

final class HomeView: UIView {

    let collectionView: UICollectionView
    var onReachedBottom: (() -> Void)?

    override init(frame: CGRect) {

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

        self.collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupView() {

        backgroundColor = .systemBackground

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground

        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func notifyIfNearBottom(indexPath: IndexPath, totalItems: Int) {
        
        let threshold = totalItems - 4
        
        if indexPath.item == threshold {
            onReachedBottom?()
        }
    }
}

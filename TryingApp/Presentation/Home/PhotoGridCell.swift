//
//  PhotoGridCell.swift
//  TryingApp
//
//  Created by Rizki Siraj on 31/01/26.
//

import UIKit

final class PhotoGridCell: UICollectionViewCell {

    static let reuseIdentifier = "PhotoGridCell"

    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupView() {

        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -4)
        ])
    }

    func configure(with photo: Photo) {
        titleLabel.text = photo.title
        imageView.image = nil

        // Very simple image loading (no cache, no lib)
        if let url = URL(string: photo.url) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data,
                      let image = UIImage(data: data) else { return }

                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }.resume()
        }
    }
}

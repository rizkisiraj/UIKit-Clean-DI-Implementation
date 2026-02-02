//
//  DetailView.swift
//  TryingApp
//
//  Created by Rizki Siraj on 02/02/26.
//

import UIKit

final class DetailView: UIView {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let favoriteButton = UIButton(type: .system)
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setupView() {
            backgroundColor = .systemBackground

            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true

            titleLabel.font = .preferredFont(forTextStyle: .headline)
            titleLabel.numberOfLines = 0

            descriptionLabel.font = .preferredFont(forTextStyle: .body)
            descriptionLabel.numberOfLines = 0

            favoriteButton.setTitle("Favorite", for: .normal)

            addSubview(scrollView)
            scrollView.addSubview(contentView)

            [imageView, titleLabel, descriptionLabel, favoriteButton].forEach {
                contentView.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }

            scrollView.translatesAutoresizingMaskIntoConstraints = false
            contentView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([

                scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                imageView.heightAnchor.constraint(equalToConstant: 260),

                titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

                descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
                descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

                favoriteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
                favoriteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                favoriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
            ])
        }

        func render(post: Post) {
            titleLabel.text = post.title
            descriptionLabel.text = post.body
        }

        func updateFavorite(isFavorite: Bool) {

            let title = isFavorite ? "Remove from Favorite" : "Add to Favorite"
            favoriteButton.setTitle(title, for: .normal)
        }
    
}


extension UIImageView {

    func load(urlString: String) {

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in

            guard let data = data,
                  let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self?.image = image
            }

        }.resume()
    }
}

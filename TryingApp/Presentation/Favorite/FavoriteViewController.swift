//
//  HomeViewController.swift
//  TryingApp
//
//  Created by Rizki Siraj on 02/02/26.
//


import UIKit
import Combine

final class FavoriteViewController: UIViewController {

    private let contentView = FavoriteView()

    private let getFavoritePostsUseCase: GetFavoritePostUseCase

    private var posts: [Post] = []
    private var cancellables = Set<AnyCancellable>()

    init(container: DependencyContainer) {
        self.getFavoritePostsUseCase = container.getFavoritePostsUseCase
        super.init(nibName: nil, bundle: nil)
        title = "Favorites"
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        bind()
    }

    // MARK: - Setup

    private func setupCollectionView() {

        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
        
        contentView.onReachedBottom = { [weak self] in
            self?.bind()
        }

        contentView.collectionView.register(
            PostGridCell.self,
            forCellWithReuseIdentifier: PostGridCell.reuseIdentifier
        )
    }

    private func bind() {
        getFavoritePostsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error:", error)
                }
            } receiveValue: { [weak self] posts in
                guard let self else { return }
                
                self.posts = posts
                self.contentView.collectionView.reloadData()
                
                print("Loaded photos:", posts.count)
                print(posts.map(\.isFavorite))
            }
            .store(in: &cancellables)
    }
}

extension FavoriteViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        posts.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PostGridCell.reuseIdentifier,
            for: indexPath
        ) as! PostGridCell

        cell.configure(with: posts[indexPath.item])

        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let spacing: CGFloat = 8
        let totalSpacing = spacing

        let width = (collectionView.bounds.width - totalSpacing) / 2

        return CGSize(width: width, height: width * 1.2)
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                            willDisplay cell: UICollectionViewCell,
                            forItemAt indexPath: IndexPath) {
    }
    
}

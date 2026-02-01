//
//  HomeViewController.swift
//  TryingApp
//
//  Created by Rizki Siraj on 31/01/26.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {

    private let contentView = HomeView()

    private let getPostsUseCase: GetPostsUseCase

    private var posts: [Post] = []
    private var cancellables = Set<AnyCancellable>()

    init(getPostsUseCase: GetPostsUseCase) {
        self.getPostsUseCase = getPostsUseCase
        super.init(nibName: nil, bundle: nil)
        title = "Posts"
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
        getPostsUseCase.execute()
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
            }
            .store(in: &cancellables)
    }
}

extension HomeViewController: UICollectionViewDataSource {

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

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let spacing: CGFloat = 8
        let totalSpacing = spacing

        let width = (collectionView.bounds.width - totalSpacing) / 2

        return CGSize(width: width, height: width * 1.2)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                            willDisplay cell: UICollectionViewCell,
                            forItemAt indexPath: IndexPath) {
    }
}

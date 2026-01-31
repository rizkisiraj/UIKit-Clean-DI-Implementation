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

    private let getPhotosUseCase: GetPhotoUseCase

    private var photos: [Photo] = []
    private var currentPage: Int = 1
    private var totalPages = 1
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(getPhotosUseCase: GetPhotoUseCase) {
        self.getPhotosUseCase = getPhotosUseCase
        super.init(nibName: nil, bundle: nil)
        title = "Photos"
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
            PhotoGridCell.self,
            forCellWithReuseIdentifier: PhotoGridCell.reuseIdentifier
        )
    }

    private func bind() {
        
        guard currentPage <= totalPages else { return }
        
        getPhotosUseCase.execute(page: 1)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error:", error)
                }
            } receiveValue: { [weak self] pagedPhotos in
                guard let self else { return }
                
                if currentPage == 1 {
                    self.totalPages = pagedPhotos.totalPages
                }
                
                if currentPage == 1 {
                    self.photos = pagedPhotos.photos
                } else {
                    self.photos.append(contentsOf: pagedPhotos.photos)
                }
                
                self.currentPage += 1
                self.contentView.collectionView.reloadData()
                
                print("Loaded photos:", photos.count)
            }
            .store(in: &cancellables)
    }
}

extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        photos.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoGridCell.reuseIdentifier,
            for: indexPath
        ) as! PhotoGridCell

        cell.configure(with: photos[indexPath.item])

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

        contentView.notifyIfNearBottom(
            indexPath: indexPath,
            totalItems: photos.count
        )
    }
}

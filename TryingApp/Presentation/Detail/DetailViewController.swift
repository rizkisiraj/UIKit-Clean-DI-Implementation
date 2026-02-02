//
//  DetailViewController.swift
//  TryingApp
//
//  Created by Rizki Siraj on 02/02/26.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {
    
    private let contentView = DetailView()
    
    private let postID: Int
    private let isFavorite: Bool
    private var currentPost: Post?
    private let getPostDetailUseCase: GetPostDetailUseCase
    private let toggleFavoritePostUseCase: ToggleFavoritePostUsecase
    private let getFavoritePostsUseCase: GetFavoritePostUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    init(postID: Int, container: DependencyContainer, isFavorite: Bool) {
        self.postID = postID
        self.isFavorite = isFavorite
        print(isFavorite)
        self.getPostDetailUseCase = container.getPostDetailUseCase
        self.toggleFavoritePostUseCase = container.toggleFavoritePostUseCase
        self.getFavoritePostsUseCase = container.getFavoritePostsUseCase
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = contentView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Detail"
        
        contentView.favoriteButton.addTarget(
            self,
            action: #selector(didTapFavorite),
            for: .touchUpInside
        )
        
        loadDetail()
    }
    
    private func loadDetail() {
        print("yes")
        getPostDetailUseCase.execute(id: postID)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] post in
                self?.currentPost = post
                self?.contentView.render(post: post)
                self?.contentView.imageView.load(urlString: "https://picsum.photos/id/\(post.id)/200/300")
                self?.contentView.updateFavorite(isFavorite: self?.isFavorite ?? false)
            }
            .store(in: &cancellables)
    }
    
    @objc
    private func didTapFavorite() {
        
        guard let post = currentPost else { return }
        
        toggleFavoritePostUseCase.execute(post: post)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                
                let updated = Post(
                    userId: post.userId, id: post.id, title: post.title, body: post.body, isFavorite: !post.isFavorite
                )
                
                self.currentPost = updated
                self.contentView.updateFavorite(isFavorite: updated.isFavorite)
            }
            .store(in: &cancellables)
    }
}

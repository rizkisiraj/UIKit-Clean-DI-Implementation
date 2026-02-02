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
    private var currentPost: Post?
    private let getPostDetailUseCase: GetPostDetailUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    init(postID: Int, container: DependencyContainer) {
        self.postID = postID
        self.getPostDetailUseCase = container.getPostDetailUseCase
        
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
                print(post)
                self?.currentPost = post
                self?.contentView.render(post: post)
                self?.contentView.imageView.load(urlString: "https://picsum.photos/id/\(post.id)/200/300")
            }
            .store(in: &cancellables)
    }
}

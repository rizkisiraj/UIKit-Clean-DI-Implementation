//
//  GetPostsUsecase.swift
//  TryingApp
//
//  Created by Rizki Siraj on 01/02/26.
//

import Foundation
import Combine

struct GetPostsUseCase {
    private let repository: PostRepository
    
    init(repository: PostRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Post], Error> {
        repository.getPosts()
    }
}

//
//  GetPostDetailUseCase.swift
//  TryingApp
//
//  Created by Rizki Siraj on 01/02/26.
//

import Foundation
import Combine

struct GetPostDetailUseCase {
    private let repository: PostRepository
    
    init(repository: PostRepository) {
        self.repository = repository
    }
    
    func execute(id: Int) -> AnyPublisher<Post, Error> {
        repository.getPostDetail(id: id)
    }
}

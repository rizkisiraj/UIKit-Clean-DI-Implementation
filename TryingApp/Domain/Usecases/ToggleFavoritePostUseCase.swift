//
//  ToggleFavoriteUsecase.swift
//  TryingApp
//
//  Created by Rizki Siraj on 30/01/26.
//

import Foundation
import Combine

struct ToggleFavoritePostUsecase {
    private let repository: PostRepository
    
    init(repository: PostRepository) {
        self.repository = repository
    }
    
    func execute(post: Post) -> AnyPublisher<Void, Never> {
        repository.toggleFavorite(post: post)
        return Just(())
            .eraseToAnyPublisher()
    }
}

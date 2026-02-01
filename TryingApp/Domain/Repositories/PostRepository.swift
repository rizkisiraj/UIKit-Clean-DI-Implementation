//
//  PostRepository.swift
//  TryingApp
//
//  Created by Rizki Siraj on 01/02/26.
//

import Combine

protocol PostRepository {
    func getPosts() -> AnyPublisher<[Post], Error>
    func getPostDetail(id: Int) -> AnyPublisher<Post, Error>
    func getFavoritePosts() -> AnyPublisher<[Post], Never>
    func toggleFavorite(post: Post)
}


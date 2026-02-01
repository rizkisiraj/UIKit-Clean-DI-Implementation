//
//  FavoriteStoragePosts.swift
//  TryingApp
//
//  Created by Rizki Siraj on 01/02/26.
//
import Combine

protocol FavoriteStoragePosts {
    func getFavorites() -> AnyPublisher<[Post], Never>
    func save(post: Post)
    func remove(postID: Int)
}

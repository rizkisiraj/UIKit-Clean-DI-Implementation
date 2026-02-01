//
//  PostRepositoryImpl.swift
//  TryingApp
//
//  Created by Rizki Siraj on 01/02/26.
//

import Foundation
import Combine

final class PostRepositoryImpl: PostRepository {
    private let apiService: APIService
    private let favoriteStorage: FavoriteStoragePosts
    
    init(apiService: APIService, favoriteStoragePosts: FavoriteStoragePosts) {
        self.apiService = apiService
        self.favoriteStorage = favoriteStoragePosts
    }
    
    func getPosts() -> AnyPublisher<[Post], Error> {

        let remotePublisher =
            apiService.fetchPosts()

        let favoriteIDsPublisher =
            favoriteStorage.getFavorites()
                .map { localDTOs in
                    Set(localDTOs.map { $0.id })
                }
                .setFailureType(to: Error.self)

        return remotePublisher
            .combineLatest(favoriteIDsPublisher)
            .map { posts, favoriteIDs in
                let updatedPosts = posts.map { post in
                    return Post(
                        userId: post.id,
                        id: post.id,
                        title: post.title,
                        description: post.description,
                        isFavorite: favoriteIDs.contains(post.id)
                    )
                }
                
                return updatedPosts
            }
            .eraseToAnyPublisher()
    }
    
    func getPostDetail(id: Int) -> AnyPublisher<Post, Error> {
        apiService.fetchPost(id: id)
            .eraseToAnyPublisher()
    }
    
    func getFavoritePosts() -> AnyPublisher<[Post], Never> {
        favoriteStorage.getFavorites().eraseToAnyPublisher()
    }
    
    func toggleFavorite(post: Post) {
        favoriteStorage.getFavorites()
            .first()
            .sink { [weak self] current in

                guard let self else { return }

                if current.contains(where: { $0.id == post.id }) {
                    self.favoriteStorage.remove(postID: post.id)
                } else {
                    self.favoriteStorage.save(post: post)
                }
            }
            .cancel()
    }

}

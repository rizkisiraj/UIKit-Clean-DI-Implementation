//
//  FavoriteStoragePostsImpl.swift
//  TryingApp
//
//  Created by Rizki Siraj on 01/02/26.
//

import Foundation
import Combine

final class FavoriteStoragePostsImpl: FavoriteStoragePosts {

    private let key = "favorite_posts"
    private let defaults: UserDefaults

    private let subject = CurrentValueSubject<[Post], Never>([])

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        loadInitial()
    }

    func getFavorites() -> AnyPublisher<[Post], Never> {
        subject.eraseToAnyPublisher()
    }

    func save(post: Post) {
        var current = subject.value

        guard current.contains(where: { $0.id == post.id }) == false else {
            return
        }

        current.append(post)
        persist(current)
    }

    func remove(postID: Int) {
        var current = subject.value
        current.removeAll { $0.id == postID }
        persist(current)
    }

    private func loadInitial() {

        guard let data = defaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Post].self, from: data)
        else {
            subject.send([])
            return
        }

        subject.send(decoded)
    }

    private func persist(_ items: [Post]) {

        guard let data = try? JSONEncoder().encode(items) else {
            return
        }

        defaults.set(data, forKey: key)
        subject.send(items)
    }
}

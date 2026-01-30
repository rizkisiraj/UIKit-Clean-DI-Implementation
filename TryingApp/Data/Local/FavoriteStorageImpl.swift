//
//  FavoriteStorageProtocol.swift
//  TryingApp
//
//  Created by Rizki Siraj on 30/01/26.
//
import Foundation
import Combine

final class FavoriteStorageImpl: FavoriteStorage {

    private let key = "favorite_photos"
    private let defaults: UserDefaults

    private let subject = CurrentValueSubject<[FavoritePhotoLocalDTO], Never>([])

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        loadInitial()
    }

    func getFavorites() -> AnyPublisher<[FavoritePhotoLocalDTO], Never> {
        subject.eraseToAnyPublisher()
    }

    func save(photo: FavoritePhotoLocalDTO) {
        var current = subject.value

        guard current.contains(where: { $0.id == photo.id }) == false else {
            return
        }

        current.append(photo)
        persist(current)
    }

    func remove(photoID: Int) {
        var current = subject.value
        current.removeAll { $0.id == photoID }
        persist(current)
    }

    private func loadInitial() {

        guard let data = defaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode([FavoritePhotoLocalDTO].self, from: data)
        else {
            subject.send([])
            return
        }

        subject.send(decoded)
    }

    private func persist(_ items: [FavoritePhotoLocalDTO]) {

        guard let data = try? JSONEncoder().encode(items) else {
            return
        }

        defaults.set(data, forKey: key)
        subject.send(items)
    }
}


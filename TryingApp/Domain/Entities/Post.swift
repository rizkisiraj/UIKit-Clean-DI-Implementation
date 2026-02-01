//
//  Post.swift
//  TryingApp
//
//  Created by Rizki Siraj on 01/02/26.
//

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let description: String
    var isFavorite: Bool = false
}

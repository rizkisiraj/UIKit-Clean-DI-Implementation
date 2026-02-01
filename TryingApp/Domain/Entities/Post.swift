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
    let body: String
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case userId
        case id
        case title
        case body
    }
}

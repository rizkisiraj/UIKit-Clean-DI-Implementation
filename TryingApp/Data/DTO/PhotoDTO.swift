//
//  PhotoDTO.swift
//  TryingApp
//
//  Created by Rizki Siraj on 30/01/26.
//

struct PhotoDTO: Decodable {
    let id: Int
    let width: Int
    let createdAt: String
    let title: String
    let description: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case id
        case width
        case title
        case description
        case url
        case createdAt = "created_at"
    }
}

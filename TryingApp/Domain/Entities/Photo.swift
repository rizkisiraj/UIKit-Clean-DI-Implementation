//
//  Photo.swift
//  TryingApp
//
//  Created by Rizki Siraj on 29/01/26.
//
import Foundation

struct Photo: Codable {
    let id: Int
    let width: Int
    let createdAt: Date
    let title: String
    let description: String
    let url: String
    var isFavorite: Bool = false
}

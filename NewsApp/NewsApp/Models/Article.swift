//
//  Article.swift
//  NewsApp
//
//  Created by Uday Kumar Kotla on 09/02/26.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let article = try? JSONDecoder().decode(Article.self, from: jsonData)

import Foundation

// MARK: - Article
struct Article: Codable {
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable ,Identifiable{
    var id : String { uuid }
    let uuid, title, description: String
    let url: String
    let imageURL: String
    let publishedAt: String
   

    enum CodingKeys: String, CodingKey {
        case uuid, title, description, url
        case imageURL = "image_url"
        case publishedAt = "published_at"
    }
}


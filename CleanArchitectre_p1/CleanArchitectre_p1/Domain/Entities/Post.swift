//
//  Post.swift
//  CleanArchitectre_p1
//
//  Created by Uday Kumar Kotla on 05/10/26.
//

import Foundation

public struct Post: Identifiable, Equatable, Hashable, Sendable {
    public let userId: Int
    public let id: Int
    public let title: String
    public let body: String

    public init(userId: Int, id: Int, title: String, body: String) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
}

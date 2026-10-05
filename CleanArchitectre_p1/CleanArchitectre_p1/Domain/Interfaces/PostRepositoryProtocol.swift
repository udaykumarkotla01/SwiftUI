//
//  PostRepositoryProtocol.swift
//  CleanArchitectre_p1
//
//  Created by Uday Kumar Kotla on 05/10/26.
//

import Foundation

public protocol PostRepositoryProtocol: Sendable {
    func getPosts() async throws -> [Post]
}

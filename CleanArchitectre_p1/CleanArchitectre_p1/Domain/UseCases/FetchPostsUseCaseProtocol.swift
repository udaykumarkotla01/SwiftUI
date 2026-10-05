//
//  FetchPostsUseCaseProtocol.swift
//  CleanArchitectre_p1
//
//  Created by Uday Kumar Kotla on 05/10/26.
//

import Foundation

public protocol FetchPostsUseCaseProtocol: Sendable {
    func execute() async throws -> [Post]
}

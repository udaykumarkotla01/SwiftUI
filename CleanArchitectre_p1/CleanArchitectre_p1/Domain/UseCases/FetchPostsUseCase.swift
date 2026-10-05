//
//  FetchPostsUseCase.swift
//  CleanArchitectre_p1
//
//  Created by Uday Kumar Kotla on 05/10/26.
//

import Foundation

public final class FetchPostsUseCase: FetchPostsUseCaseProtocol {
    private let repository: PostRepositoryProtocol

    public init(repository: PostRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws -> [Post] {
        return try await repository.getPosts()
    }
}

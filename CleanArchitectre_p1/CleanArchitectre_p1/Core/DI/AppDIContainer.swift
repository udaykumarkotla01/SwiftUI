//
//  AppDIContainer.swift
//  CleanArchitectre_p1
//
//  Created by Uday Kumar Kotla on 05/10/26.
//

import SwiftUI

/// Dependency Injection Container to assemble Clean Architecture components.
///
/// Flow:
/// View → ViewModel → Use Case → Use Case Repository Protocol → Repository Implementation
@MainActor
public final class AppDIContainer {
    public static let shared = AppDIContainer()

    private lazy var postRepository: PostRepositoryProtocol = {
        PostRepository()
    }()

    private lazy var fetchPostsUseCase: FetchPostsUseCaseProtocol = {
        FetchPostsUseCase(repository: postRepository)
    }()

    public func makePostListView() -> some View {
        let viewModel = PostListViewModel(fetchPostsUseCase: fetchPostsUseCase)
        return PostListView(viewModel: viewModel)
    }
}

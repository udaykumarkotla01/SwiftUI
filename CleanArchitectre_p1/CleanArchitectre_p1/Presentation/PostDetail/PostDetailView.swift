//
//  PostDetailView.swift
//  CleanArchitectre_p1
//
//  Created by Uday Kumar Kotla on 01/10/26.
//

import SwiftUI

public struct PostDetailView: View {
    public let post: Post

    public init(post: Post) {
        self.post = post
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 12) {
                    HStack(spacing: 6) {
                        Image(systemName: "number")
                            .font(.caption)
                        Text("Post ID \(post.id)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.12))
                    .foregroundColor(.blue)
                    .clipShape(Capsule())

                    HStack(spacing: 6) {
                        Image(systemName: "person.circle.fill")
                            .font(.caption)
                        Text("Author \(post.userId)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.purple.opacity(0.12))
                    .foregroundColor(.purple)
                    .clipShape(Capsule())

                    Spacer()
                }

                Text(post.title.capitalized)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Divider()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Content")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)

                    Text(post.body)
                        .font(.body)
                        .lineSpacing(6)
                        .foregroundColor(.primary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)

            }
            .padding(20)
        }
        .navigationTitle("Post #\(post.id)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PostDetailView(
            post: Post(
                userId: 1,
                id: 1,
                title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                body: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
            )
        )
    }
}

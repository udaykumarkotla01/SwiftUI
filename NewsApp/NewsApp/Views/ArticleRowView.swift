//
//  ArticleRowView.swift
//  NewsApp
//
//  Created by Uday Kumar Kotla on 11/02/26.
//

import SwiftUI

struct ArticleRowView: View {
    let datum : Datum
    var body: some View {
        HStack(alignment: .center, spacing: 10){
            if let urlString = datum.imageURL,
               let url = URL(string: urlString) {
                
                AsyncImage(url: url)
                {
                    phase in
                    switch phase {
                    case .empty:
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.thinMaterial)
                            .frame(width: 100, height: 100)
                            .overlay {
                                ProgressView()
                            }
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipped()
                            .cornerRadius(10)
                   
                    case .failure(_):
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.thinMaterial)
                            .frame(width: 100, height: 100)
                            .overlay {
                                ProgressView()
                            }
                    @unknown default:
                        EmptyView()
                    }
                }

            }
            VStack(alignment: .leading){
                Text(datum.title).font(.headline).foregroundStyle(.primary)
                Text(datum.description).font(.subheadline).foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
    }
}

#Preview {
    ArticleRowView(datum: Datum(
        uuid: "16a7cbcc-6480-4c95-a1fb-557037778382",
        title: "Trump has a plan to steal the midterms. It will probably fail.",
        description: "The threat of Donald Trump trying to rig the 2026 midterm elections has never been higher. After the FBI’s raid of an election office in Fulton County — mys...",
        url: "https://www.vox.com/politics/478263/trump-midterms-2026-rigged-election-fulton-county-gabbard-bondi",
        imageURL: "https://platform.vox.com/wp-content/uploads/sites/2/2026/02/gettyimages-2257975335.jpg?quality=90&strip=all&crop=0%2C10.732984293194%2C100%2C78.534031413613&w=1200",
        publishedAt: "2026-02-09T11:09:25.000000Z"
    ))
}

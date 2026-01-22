//
//  ContentView.swift
//  UMovies
//
//  Created by Uday Kumar Kotla on 21/01/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MoviesListView()
        }
        .padding()
    }
}

#Preview {
    NavigationStack{
        ContentView()
    }
}

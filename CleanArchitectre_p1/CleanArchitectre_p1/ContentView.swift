//
//  ContentView.swift
//  CleanArchitectre_p1
//
//  Created by Uday Kumar Kotla on 05/10/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        AppDIContainer.shared.makePostListView()
    }
}

#Preview {
    ContentView()
}

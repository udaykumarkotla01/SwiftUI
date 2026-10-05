//
//  CleanArchitectre_p1App.swift
//  CleanArchitectre_p1
//
//  Created by Uday Kumar Kotla on 05/10/26.
//

import SwiftUI

@main
struct CleanArchitectre_p1App: App {
    var body: some Scene {
        WindowGroup {
            AppDIContainer.shared.makePostListView()
        }
    }
}

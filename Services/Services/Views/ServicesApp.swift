//
//  ServicesApp.swift
//  Services
//
//  Created by Uday Kumar Kotla on 06/01/26.
//

import SwiftUI
import ServicesSampleData

@main
struct ServicesApp: App {
    @StateObject private var coordinator = AppCoordinator()
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path){
                ServiceListView()
                    .environmentObject(coordinator)
                    .navigationDestination(for: Service.self){
                        service in
                       ServiceDetailView(service: service)
                    }
            }
        }
    }
}

//
//  AppCoordinator.swift
//  Services
//
//  Created by Uday Kumar Kotla on 06/01/26.
//

import SwiftUI
import ServicesSampleData
import Combine

// Using the MVVM + Coordinator pattern
final class AppCoordinator : ObservableObject{
    
    @Published var path = NavigationPath()
    
    func showDetails(for service: Service) {
        path.append(service)
    }
    
    func pop(){
        path.removeLast()
    }
}

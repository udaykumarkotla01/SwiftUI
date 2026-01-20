//
//  ServiceListView.swift
//  Services
//
//  Created by Uday Kumar Kotla on 06/01/26.
//

import SwiftUI
import ServicesSampleData

struct ServiceListView: View {
    @EnvironmentObject var Coordinator: AppCoordinator
    @StateObject var viewModel : ServicesViewModel = ServicesViewModel()
    var body: some View {
        VStack{
            List{
                ForEach(viewModel.services,id: \.id){
                    service in
                    Button{
                        Coordinator.showDetails(for: service)
                    }
                    label:{
                        ServiceCardView(service: service)
                    }
                }
                .navigationTitle("Services")
            }  .refreshable {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                viewModel.loadServices()
            }
        }
    }
}


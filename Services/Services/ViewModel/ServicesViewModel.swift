//
//  ServicesViewModel.swift
//  Services
//
//  Created by Uday Kumar Kotla on 06/01/26.
//

import Foundation
import ServicesSampleData
import Combine

class ServicesViewModel : ObservableObject{
    @Published var services : [Service] = []
    
    init(){
        loadServices()
    }
    
    func loadServices() {
        services = SampleData.generateServices()
    }
    
    //optional: when we have load more option when scrolling down
    func loadMoreServices() {
        services.append(contentsOf: SampleData.generateServices(count: 20))
    }
    
    func getSingleService(){
        services = [SampleData.generateSingleService()]
    }
}

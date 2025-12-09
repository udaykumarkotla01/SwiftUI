//
//  PassengerListView.swift
//  TitanicCSV
//
//  Created by Uday Kumar Kotla on 07/12/25.
//

import SwiftUI

struct PassengerListView: View {
    @State var vm = TitanicViewModel()
    var body: some View {
        NavigationStack{
            Group{
                if(vm.isLoading){
                    ProgressView("Loading Data...")
                }
                else{
                    List(vm.passengers){ passenger in
                        VStack(alignment: .leading){
                            Text("Name : \(passenger.name ?? "Not found")")
                            Text("Age : \(passenger.age ?? -1)")
                            Text("Sex : \(passenger.sex ?? "Not found")")
                            Text("Survived : \(passenger.survived ? "Yes" : "No")")
                        }
                        
                    }
                }
            }.navigationTitle("Titanic Passenger List")
                .task{
                    await vm.fetchTitanicData()
                }
            
        } .ignoresSafeArea(.all)
    }
}

#Preview {
    PassengerListView()
}

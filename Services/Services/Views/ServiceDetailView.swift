//
//  ServiceDetailView.swift
//  Services
//
//  Created by Uday Kumar Kotla on 06/01/26.
//

import SwiftUI
import ServicesSampleData
import MapKit

struct ServiceDetailView: View {
    let service: Service
    
    //Hardcoded coordinates
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        VStack(alignment: .leading){
            Map(coordinateRegion: $region, annotationItems: [region.center]) { location in
                MapMarker(coordinate: location, tint: .red)
            }
            
            HStack{
                Text(service.title).font(.title).bold().foregroundStyle(.black)
                Spacer()
                ServiceBadgeView(service: service)
            }
            HStack{
                Image("user-circle").renderingMode(.template).foregroundStyle(.blue)
                VStack(alignment: .leading){
                    Text("Customer").bold()
                    Text(service.customerName)
                }
            }
            HStack{
                Image("file-description").renderingMode(.template).foregroundStyle(.blue)
                VStack(alignment: .leading){
                    Text("Description").bold()
                    Text(service.description)
                }
            }
            HStack{
                Image("clock-hour-4").renderingMode(.template).foregroundStyle(.blue)
                VStack(alignment: .leading){
                    Text("Scheduled Time").bold()
                    Text(formatServiceDate(from: service.scheduledDate))
                }
            }
            HStack{
                Image("map-pin").renderingMode(.template).foregroundStyle(.blue)
                VStack(alignment: .leading){
                    Text("Location").bold()
                    Text(service.location)
                }
            }
            HStack{
                Image("message-2").renderingMode(.template).foregroundStyle(.blue)
                VStack(alignment: .leading){
                    Text("Service Notes").bold()
                    Text(service.serviceNotes)
                }
            }
        }.navigationTitle("Service Detail")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
    }
}

extension CLLocationCoordinate2D: Identifiable {
    public var id: String { "\(latitude),\(longitude)" }
}


#Preview {
    ServiceDetailView(service: Service(id: "009", title: "Roofing Inspection", customerName: "Green Valley Apartments", description: "Interior and exterior painting with premium quality materials", status: ServicesSampleData.ServiceStatus.scheduled, priority: ServicesSampleData.Priority.medium, scheduledDate: "2026-01-01T12:00:00Z", location: "258 Retail Center", serviceNotes: "Service includes detailed inspection report and recommendations"))
}

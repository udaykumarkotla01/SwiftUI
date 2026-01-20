//
//  ServiceCardView.swift
//  Services
//
//  Created by Uday Kumar Kotla on 06/01/26.
//

import SwiftUI
import ServicesSampleData

struct ServiceCardView: View {
    var service : Service
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(service.title).bold().font(.title).foregroundStyle(.black)
                Spacer()
                Circle().frame(width: 8, height: 8).foregroundStyle(service.status.statusColor)
            }
            HStack{
                Image("user-circle").renderingMode(.template).foregroundStyle(.blue)
                Text(service.customerName).foregroundStyle(.gray)
            }
            HStack{
                Image("file-description").renderingMode(.template).foregroundStyle(.blue)
                Text(service.description).foregroundStyle(.gray)
            }
            HStack{
                ServiceBadgeView(service: service)
                Spacer()
                Text(formatServiceDate(from: service.scheduledDate)).foregroundStyle(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 2)
        )
    }
}

#Preview {
    ServiceCardView(service: Service(id: "009", title: "Roofing Inspection", customerName: "Green Valley Apartments", description: "Interior and exterior painting with premium quality materials", status: ServicesSampleData.ServiceStatus.scheduled, priority: ServicesSampleData.Priority.medium, scheduledDate: "2026-01-01T12:00:00Z", location: "258 Retail Center", serviceNotes: "Service includes detailed inspection report and recommendations"))
}

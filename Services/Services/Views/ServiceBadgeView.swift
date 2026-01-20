//
//  ServiceBadgeView.swift
//  Services
//
//  Created by Uday Kumar Kotla on 06/01/26.
//

import SwiftUI
import ServicesSampleData

struct ServiceBadgeView: View {
    let service: Service
    var body: some View {
        VStack{
            HStack{
                Rectangle()
                    .frame(width: 18,height: 18)
                    .padding(.leading,4)
                Text(service.status.statusText)
                    .padding(8)
            }.foregroundStyle(service.status.statusColor)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(service.status.statusColor.opacity(0.3))
        )
        
    }
}

#Preview {
    ServiceBadgeView(service: Service(id: "009", title: "Roofing Inspection", customerName: "Green Valley Apartments", description: "Interior and exterior painting with premium quality materials", status: ServicesSampleData.ServiceStatus.scheduled, priority: ServicesSampleData.Priority.medium, scheduledDate: "2026-01-01T12:00:00Z", location: "258 Retail Center", serviceNotes: "Service includes detailed inspection report and recommendations"))
}

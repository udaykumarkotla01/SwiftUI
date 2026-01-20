//
//  ServiceStatusStyling.swift
//  Services
//
//  Created by Uday Kumar Kotla on 06/01/26.
//

import Foundation
import SwiftUI
import ServicesSampleData

extension ServiceStatus{
    var statusText: String {
        switch self{
        case .active : "Active"
        case .completed : "Completed"
        case .inProgress : "In Progress"
        case .scheduled : "Scheduled"
        case .urgent : "Urgent"
        }
    }
    
    var statusColor: Color {
        switch self{
        case .active : .green
        case .completed : .green
        case .inProgress : .yellow
        case .scheduled : .green
        case .urgent : .orange
        }
    }
}


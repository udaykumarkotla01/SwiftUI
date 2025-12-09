//
//  Passenger.swift
//  TitanicCSV
//
//  Created by Uday Kumar Kotla on 07/12/25.
//

import Foundation
struct Passenger: Identifiable {
    let id : Int
    let survived : Bool
    let pclass: Int
    let name: String?
    let sex: String?
    let age: Int?
}

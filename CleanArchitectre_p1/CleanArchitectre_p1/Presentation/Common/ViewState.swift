//
//  ViewState.swift
//  CleanArchitectre_p1
//
//  Created by Uday Kumar Kotla on 05/10/26.
//

import Foundation

public enum ViewState<T: Equatable>: Equatable {
    case idle
    case loading
    case loaded(T)
    case error(String)
}

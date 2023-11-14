//
//  Result.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 13/11/23.
//

import Foundation

public enum Result<T: Equatable>: Equatable {
    case success(T)
    case failure(Error)

    public static func == (lhs: Result<T>, rhs: Result<T>) -> Bool {
        return true
    }
}

//
//  NetworkResponseAPI.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 13/11/23.
//

import Foundation

public enum NetworkResponseApi: Error {
    case success(String)
    case authenticationError
    case badRequest
    case outdated
    case failed(String)
    case noData
    case unableToDecode
}

extension NetworkResponseApi: Equatable {
    public static func == (lhs: NetworkResponseApi, rhs: NetworkResponseApi) -> Bool {
        switch (lhs, rhs) {
            case (NetworkResponseApi.success, NetworkResponseApi.success),
                (NetworkResponseApi.authenticationError, NetworkResponseApi.authenticationError),
                (NetworkResponseApi.badRequest, NetworkResponseApi.badRequest),
                (NetworkResponseApi.outdated, NetworkResponseApi.outdated),
                (NetworkResponseApi.failed, NetworkResponseApi.failed),
                (NetworkResponseApi.noData, NetworkResponseApi.noData),
                (NetworkResponseApi.unableToDecode, NetworkResponseApi.unableToDecode):
                return true
            default:
                return false
        }
    }
}

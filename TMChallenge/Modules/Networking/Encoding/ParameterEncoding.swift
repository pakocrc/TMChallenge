//
//  ParameterEncoding.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 13/11/23.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum NetworkError: String, Error {
    case parametersNil  = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL     = "URL is nil."
}


public enum ParameterEncoding {
    case urlEncoding
    
    public func encode(
        urlRequest: inout URLRequest,
        bodyParameters: Parameters?,
        urlParameters: Parameters?) throws {
        do {
            switch self {
                case .urlEncoding:
                    guard let urlParameters = urlParameters else { return }
                    try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
}

public struct URLParameterEncoder: ParameterEncoder {
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw NetworkError.missingURL }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {

            urlComponents.queryItems = [URLQueryItem]()

            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")

                urlComponents.queryItems?.append(queryItem)
            }

            urlRequest.url = urlComponents.url
        }

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}

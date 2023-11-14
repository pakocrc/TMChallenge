//
//  EndPointType.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 13/11/23.
//

import Foundation

public enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
}

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
    case request
    case requestParameters(bodyParameters: Parameters?, bodyEncoding: ParameterEncoding, urlParameters: Parameters?)
    case requestParametersAndHeaders(bodyParameters: Parameters?, bodyEncoding: ParameterEncoding, urlParameters: Parameters?, additionHeaders: HTTPHeaders?)
}

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

public enum Endpoints {
    // MARK: Events
    case events(page: Int)
    
}

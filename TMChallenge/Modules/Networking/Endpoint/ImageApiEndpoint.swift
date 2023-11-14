//
//  ImageApiEndpoint.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 14/11/23.
//

import Foundation

public enum ImageApiEndpoint {
    case image(imagePath: String)
}

extension ImageApiEndpoint: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: "https://s1.ticketm.net/dam/a/") else { fatalError("baseURL could not be configured.")}
        return url
    }

    var cachePolicy: URLRequest.CachePolicy {
        return .reloadIgnoringLocalAndRemoteCacheData
    }

    var path: String {
        switch self {
        case .image(let imagePath):
                let path = imagePath.replacingOccurrences(of: "https://s1.ticketm.net/dam/a/", with: "")
                return path
        }
    }

    var httpMethod: HTTPMethod {
        return .get
    }

    var task: HTTPTask {
        switch self {
            case .image:
                return .requestParameters(bodyParameters: nil,
                                          bodyEncoding: .urlEncoding,
                                          urlParameters: [:])
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}

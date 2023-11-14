//
//  EventsApiEndpoint.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 13/11/23.
//

import Foundation

let publicApiKey: String = "DW0E98NrxUIfDDtNN7ijruVSm60ryFLX"

public enum EventsApiEndpoint {
    // MARK: Events
    case events(page: Int)
    case searchEvents(query: String, page: Int)
}

extension EventsApiEndpoint: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: "https://app.ticketmaster.com/discovery/v2/") else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    

    var cachePolicy: URLRequest.CachePolicy {
        return .reloadIgnoringLocalAndRemoteCacheData
    }

    var path: String {
        switch self {
            case .events, .searchEvents:
                return "events"
        }
    }

    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
            case .events(let page):
                return .requestParameters(bodyParameters: nil,
                                          bodyEncoding: .urlEncoding,
                                          urlParameters: ["page": page,
                                                          "apikey": publicApiKey])
            case .searchEvents(let query, let page):
                return .requestParameters(bodyParameters: nil,
                                          bodyEncoding: .urlEncoding,
                                          urlParameters: ["page": page,
                                                          "keyword": query,
                                                          "apikey": publicApiKey])
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}

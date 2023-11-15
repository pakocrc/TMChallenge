//
//  EventsNetworkServiceMock.swift
//  TMChallengeTests
//
//  Created by Francisco Jose Cordoba Rojas on 15/11/23.
//

import Combine
import Foundation
import TMChallenge

public final class EventsNetworkServiceMock: EventsNetworkServiceProtocol {
    public init() {
        
    }
    
    // MARK: - Events
    public func eventsApi(page: Int) -> AnyPublisher<EventsApiResponse, NetworkResponseApi> {
        return AnyPublisher<EventsApiResponse, NetworkResponseApi>.create { [weak self] promise in
            guard let `self` = self else { return Disposable() }
            
            if page == 0 {
                do {
                    let responseData = readJsonFile(filename: "GetEventsResponse")
                    let apiResponse = try JSONDecoder().decode(EventsApiResponse.self, from: responseData)
                    
                    promise.onNext(apiResponse)
                    promise.onComplete()
                    
                } catch let exception {
                    print("🔴 [Networking] [EventsNetworkService] [eventsApi] An error occurred: \(exception.localizedDescription)")
                    promise.onError(NetworkResponseApi.unableToDecode)
                    promise.onComplete()
                }
                
            } else {
                print("🔴 [Networking] [EventsNetworkService] [eventsApi] An error occurred.")
                promise.onError(NetworkResponseApi.unableToDecode)
                promise.onComplete()
            }
            
            return Disposable()
        }
    }
    
    public func searchEventsApi(query: String, page: Int) -> AnyPublisher<EventsApiResponse, NetworkResponseApi> {
        return AnyPublisher<EventsApiResponse, NetworkResponseApi>.create { [weak self] promise in
            guard let `self` = self else { return Disposable() }
            
            if query == "Disney" {
                do {
                    let responseData = readJsonFile(filename: "SearchEventsResponse")
                    let apiResponse = try JSONDecoder().decode(EventsApiResponse.self, from: responseData)
                    
                    promise.onNext(apiResponse)
                    promise.onComplete()
                    
                } catch let exception {
                    print("🔴 [Networking] [EventsNetworkService] [searchEventsApi] An error occurred: \(exception.localizedDescription)")
                    promise.onError(NetworkResponseApi.unableToDecode)
                    promise.onComplete()
                }
                
            } else {
                print("🔴 [Networking] [EventsNetworkService] [searchEventsApi] An error occurred.")
                promise.onError(NetworkResponseApi.unableToDecode)
                promise.onComplete()
            }
            
            return Disposable()
        }
    }
    
    private func readJsonFile(filename: String) -> Data {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: filename, ofType: "json") else {
            fatalError("\(filename).json not found")
        }
        
        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert UnitTestData.json to String")
        }
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Unable to convert UnitTestData.json to Data")
        }
        
        return jsonData
    }
}

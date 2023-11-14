//
//  EventsNetworkServiceProtocol.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 13/11/23.
//

import Combine
import Foundation

public protocol EventsNetworkServiceProtocol {
    func eventsApi(page: Int) -> AnyPublisher<EventsApiResponse, NetworkResponseApi>
}

public final class EventsNetworkService: EventsNetworkServiceProtocol {
    private let networkManager = NetworkManager<EventsApiEndpoint>()
    
    public init() {
        
    }
    
    // MARK: - Events
    public func eventsApi(page: Int) -> AnyPublisher<EventsApiResponse, NetworkResponseApi> {
        return AnyPublisher<EventsApiResponse, NetworkResponseApi>.create { [weak self] promise in
            guard let `self` = self else { return Disposable() }
            
            let eventsEndpoint: EventsApiEndpoint = .events(page: page)
            
            self.networkManager.request (eventsEndpoint, completion: { [weak self] data, response, error in
                guard let `self` = self else { return }
                
                if error != nil {
                    let errorDescription = error?.localizedDescription ?? ""
                    print("🔴 [Networking] [EventsNetworkService] [eventsApi] An error occurred: \(errorDescription)")
                    promise.onError(NetworkResponseApi.failed(errorDescription))
                    promise.onComplete()
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = self.networkManager.handleNetworkResponse(response)
                    switch result {
                        case .success:
                            guard let responseData = data else {
                                promise.onError(NetworkResponseApi.noData)
                                promise.onComplete()
                                return
                            }
                            do {
                                let apiResponse = try JSONDecoder().decode(EventsApiResponse.self, from: responseData)

                                promise.onNext(apiResponse)
                                promise.onComplete()

                            } catch let exception {
                                print("🔴 [Networking] [EventsNetworkService] [eventsApi] An error occurred: \(exception.localizedDescription)")
                                promise.onError(NetworkResponseApi.unableToDecode)
                                promise.onComplete()
                            }
                        case .failure(let networkFailureError):
                            print("🔴 [Networking] [EventsNetworkService] [eventsApi] An error occurred: \(networkFailureError)")
                            promise.onError(NetworkResponseApi.failed(networkFailureError.localizedDescription))
                            promise.onComplete()
                    }
                }
            })
            return Disposable()
        }
    }
    
    public func searchEventsApi(query: String, page: Int) -> AnyPublisher<EventsApiResponse, NetworkResponseApi> {
        return AnyPublisher<EventsApiResponse, NetworkResponseApi>.create { [weak self] promise in
            guard let `self` = self else { return Disposable() }

            self.networkManager.request(.searchEvents(query: query, page: page), completion: { [weak self] data, response, error in
                guard let `self` = self else { return }

                if error != nil {
                    let errorDescription = error?.localizedDescription ?? ""
                    print("🔴 [Networking] [EventNetworkService] [searchEventApi] An error occurred: \(errorDescription)")
                    promise.onError(NetworkResponseApi.failed(errorDescription))
                    promise.onComplete()
                }

                if let response = response as? HTTPURLResponse {
                    let result = self.networkManager.handleNetworkResponse(response)
                    switch result {
                        case .success:
                            guard let responseData = data else {
                                promise.onError(NetworkResponseApi.noData)
                                promise.onComplete()
                                return
                            }
                            do {
                                let apiResponse = try JSONDecoder().decode(EventsApiResponse.self, from: responseData)

                                promise.onNext(apiResponse)
                                promise.onComplete()

                            } catch let exception {
                                print("🔴 [Networking] [EventNetworkService] [searchEventApi] An error occurred: \(exception.localizedDescription)")
                                promise.onError(NetworkResponseApi.unableToDecode)
                                promise.onComplete()
                            }
                        case .failure(let networkFailureError):
                            print("🔴 [Networking] [EventNetworkService] [searchEventApi] An error occurred: \(networkFailureError)")
                            promise.onError(NetworkResponseApi.failed(networkFailureError.localizedDescription))
                            promise.onComplete()
                    }
                }
            })
            return Disposable()
        }
    }
}

//
//  EventsService.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 13/11/23.
//

import Combine
import Foundation

public final class EventsService: EventsNetworkServiceProtocol {
    private let eventsNetworkService: EventsNetworkService

    private var cancellable = Set<AnyCancellable>()

    private static let sharedEventsService: EventsService = {
        return EventsService(eventsNetworkService: EventsNetworkService())
    }()

    private init(eventsNetworkService: EventsNetworkService) {
        self.eventsNetworkService = eventsNetworkService
    }

    static func shared() -> EventsService {
        return sharedEventsService
    }

    // MARK: - Public Methods
    public func events(page: Int) -> AnyPublisher<EventsTM, NetworkResponse> {
        return AnyPublisher<EventsTM, NetworkResponse>.create { [weak self] promise in
            guard let `self` = self else { return Disposable() }

            self.eventsApi(page: page)
                .sink(receiveCompletion: { [weak self] networkResponse in
                    guard let `self` = self else { return }
                    switch networkResponse {
                    case .failure(let response):
                        let newNetworkResponse = self.handleNetworkResponse(networkResponseApi: response)
                        promise.onError(newNetworkResponse)
                    default: break
                    }
                }, receiveValue: { apiResponse in
                    let response = EventsTM(apiResponse: apiResponse)
                    promise.onNext(response)
                }).store(in: &self.cancellable)

            return Disposable()
        }
    }

    // MARK: - Network Service
    // MARK: Events
    public func eventsApi(page: Int) -> AnyPublisher<EventsApiResponse, NetworkResponseApi> {
        return self.eventsNetworkService.eventsApi(page: page)
    }

    // MARK: - Helpers
    private func handleNetworkResponse(networkResponseApi: NetworkResponseApi) -> NetworkResponse {
        var newNetworkResponse: NetworkResponse

        switch networkResponseApi {
        case .authenticationError: newNetworkResponse = .authenticationError
        case .success(let response): newNetworkResponse = .success(response)
        case .badRequest: newNetworkResponse = .badRequest
        case .outdated: newNetworkResponse = .outdated
        case .failed(let error): newNetworkResponse = .failed(error)
        case .noData: newNetworkResponse = .noData
        case .unableToDecode: newNetworkResponse = .unableToDecode
        }
        return newNetworkResponse
    }
}

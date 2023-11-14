//
//  EventsViewModel.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 13/11/23.
//

import Foundation
import Combine

public protocol EventsVMInputs: AnyObject {
    /// Call to get the new events.
    func fetchEvents()
    
    /// Call when a event is selected.
    func eventSelected(event: EventTM)
}

public protocol EventsVMOutputs: AnyObject {
    /// Emits to get the new events.
    func fetchEventsAction() -> CurrentValueSubject<[EventTM]?, Never>
    
    /// Emits when loading.
    func loading() -> CurrentValueSubject<Bool, Never>

    /// Emits when a event is selected.
    func eventSelectedAction() -> PassthroughSubject<EventTM, Never>

    /// Emits when all the events were fetched.
    func finishedFetchingAction() -> CurrentValueSubject<Bool, Never>

    /// Emits when an error occurred.
    func showError() -> PassthroughSubject<String, Never>
}

public protocol EventsVMTypes: AnyObject {
    var inputs: EventsVMInputs { get }
    var outputs: EventsVMOutputs { get }
}

public final class EventsViewModel: ObservableObject, Identifiable, EventsVMInputs, EventsVMOutputs, EventsVMTypes {
    // MARK: Constants
    private let eventsService: EventsService
    
    // MARK: Variables
    public var inputs: EventsVMInputs { return self }
    public var outputs: EventsVMOutputs { return self }
    private var cancellable = Set<AnyCancellable>()
    private var page = 0
    
    init(eventsService: EventsService) {
        self.eventsService = eventsService
        
        
        let getEvents = self.fetchEventsProperty
            .flatMap({ [weak self] _ -> AnyPublisher<EventsTM, Never> in
                guard let `self` = self else { return Empty(completeImmediately: true).eraseToAnyPublisher() }

                self.loadingProperty.value = true

//                switch self.searchCriteriaActionProperty.value {
//                case .discover(let genre):
//                    if let genreName = genre.name {
//                        self.setViewTitlePropery.send(genreName)
//                    }
//                default: break
//                }

                return eventsService.events(page: self.page)
                    .retry(2)
                    .mapError({ [weak self] networkResponse -> NetworkResponse in
                        print("🔴 [EventsViewModel] [init] Received completion error. Error: \(networkResponse.localizedDescription)")
                        self?.loadingProperty.value = false
                        self?.handleNetworkResponseError(networkResponse)
                        return networkResponse
                    })
                    .replaceError(with: EventsTM())
                    .eraseToAnyPublisher()
            }).share()

        getEvents
            .sink(receiveCompletion: { [weak self] completionReceived in
                guard let `self` = self else { return }

                self.loadingProperty.value = false
                switch completionReceived {
                    case .failure(let error):
                        print("🔴 [EventsViewModel] [init] Received completion error. Error: \(error.localizedDescription)")
                        self.showErrorProperty.send(NSLocalizedString("network_response_error", comment: "Network error message"))
                    default: break
                }
            }, receiveValue: { [weak self] events in
                guard let `self` = self else { return }

                self.loadingProperty.value = false
                
                print("🔸 Number of events: \(events.embedded?.events.count ?? 0)")

                if let numberOfResults = events.embedded?.events.count, numberOfResults != 0 {
                    print("🔸 Events Response [page: \(events.page?.number ?? 0), size: \(events.page?.size ?? 0), number of events: \(events.embedded?.events.count ?? 0)]")
                    
                    self.page += 1
                    
                    if let numberOfPages = events.page?.totalPages {
                        self.finishedFetchingActionProperty.send(self.page >= numberOfPages)
                    }
                    
                    self.fetchEventsActionProperty.send(events.embedded?.events)
                }
            }).store(in: &cancellable)
    }
    
    // MARK: - ⬇️ INPUTS Definition
    private let fetchEventsProperty = PassthroughSubject<Void, Never>()
    public func fetchEvents() {
        fetchEventsProperty.send(())
    }
    
    private let eventSelectedProperty = PassthroughSubject<EventTM, Never>()
    public func eventSelected(event: EventTM) {
        eventSelectedProperty.send(event)
    }

    // MARK: - ⬆️ OUTPUTS Definition
    private let fetchEventsActionProperty = CurrentValueSubject<[EventTM]?, Never>([])
    public func fetchEventsAction() -> CurrentValueSubject<[EventTM]?, Never> {
        return fetchEventsActionProperty
    }
    
    private let loadingProperty = CurrentValueSubject<Bool, Never>(false)
    public func loading() -> CurrentValueSubject<Bool, Never> {
        return loadingProperty
    }

    private let eventSelectedActionProperty = PassthroughSubject<EventTM, Never>()
    public func eventSelectedAction() -> PassthroughSubject<EventTM, Never> {
        return eventSelectedActionProperty
    }

    private let finishedFetchingActionProperty = CurrentValueSubject<Bool, Never>(false)
    public func finishedFetchingAction() -> CurrentValueSubject<Bool, Never> {
        return finishedFetchingActionProperty
    }

    private let showErrorProperty = PassthroughSubject<String, Never>()
    public func showError() -> PassthroughSubject<String, Never> {
        return showErrorProperty
    }
    
    // MARK: - ⚙️ Helpers
    private func handleNetworkResponseError(_ networkResponse: NetworkResponse) {
        print("❌ Network response error: \(networkResponse.localizedDescription)")
//        self.showErrorProperty.send(NSLocalizedString("network_response_error", comment: "Network response error"))
    }

    // MARK: - 🗑 Deinit
    deinit {
        print("🗑", "EventsVM deinit.")
    }
}

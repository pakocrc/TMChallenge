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
    
    /// Call when the search controller change its status.
    func searchControllerDidChange(isActive: Bool)
    
    /// Call when the search text did change.
    func searchTextDidChange(searchQuery: String?)
}

public protocol EventsVMOutputs: AnyObject {
    /// Emits to get the new events.
    func fetchEventsAction() -> CurrentValueSubject<[EventTM]?, Never>
    
    /// Emits when loading.
    func loading() -> CurrentValueSubject<Bool, Never>

    /// Emits when all the events were fetched.
    func finishedFetchingAction() -> CurrentValueSubject<Bool, Never>

    /// Emits when an error occurred.
    func showError() -> PassthroughSubject<String, Never>
    
    /// Emits when the search controller change its status.
    func searchControllerDidChangeAction() -> PassthroughSubject<Bool, Never>
}

public protocol EventsVMTypes: AnyObject {
    var inputs: EventsVMInputs { get }
    var outputs: EventsVMOutputs { get }
}

public final class EventsViewModel: ObservableObject, Identifiable, EventsVMInputs, EventsVMOutputs, EventsVMTypes {
    // MARK: Constants
    private let eventsService: EventsServiceProtocol
    
    // MARK: Variables
    public var inputs: EventsVMInputs { return self }
    public var outputs: EventsVMOutputs { return self }
    private var cancellable = Set<AnyCancellable>()
    public var page = 0
    
    public init(eventsService: EventsServiceProtocol) {
        self.eventsService = eventsService
        self.loadingProperty.value = true
        self.searchControllerDidChangeProperty
            .sink { [weak self] isActive in
                self?.searchControllerDidChangeActionProperty.send(isActive)
                
            }.store(in: &cancellable)
        
        let getEvents = self.fetchEventsProperty
            .flatMap({ [weak self] _ -> AnyPublisher<EventsTM, Never> in
                guard let `self` = self else { return Empty(completeImmediately: true).eraseToAnyPublisher() }

                self.loadingProperty.value = true

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
            .sink(receiveValue: { [weak self] events in
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
        
        let searchEvents = searchTextDidChangeProperty
            .filter({ !($0?.isEmpty ?? true) && ($0?.count ?? 0) >= 4 })
            .flatMap({ [weak self] queryText -> AnyPublisher<EventsTM, Never> in
                guard let `self` = self else { return Empty(completeImmediately: true).eraseToAnyPublisher() }

                self.loadingProperty.value = true
                return eventsService.searchEvents(query: queryText ?? "", page: 0)
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

        searchEvents
            .sink(receiveValue: { [weak self] events in
                guard let `self` = self else { return }
                
                self.loadingProperty.value = false
                self.fetchEventsActionProperty.value = events.embedded?.events
                
            }).store(in: &cancellable)
    }
    
    // MARK: - ⬇️ INPUTS Definition
    private let fetchEventsProperty = PassthroughSubject<Void, Never>()
    public func fetchEvents() {
        fetchEventsProperty.send(())
    }
    
    private let searchTextDidChangeProperty = PassthroughSubject<String?, Never>()
    public func searchTextDidChange(searchQuery: String?) {
        searchTextDidChangeProperty.send(searchQuery)
    }

    private let searchControllerDidChangeProperty = PassthroughSubject<Bool, Never>()
    public func searchControllerDidChange(isActive: Bool) {
        searchControllerDidChangeProperty.send(isActive)
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

    private let finishedFetchingActionProperty = CurrentValueSubject<Bool, Never>(false)
    public func finishedFetchingAction() -> CurrentValueSubject<Bool, Never> {
        return finishedFetchingActionProperty
    }

    private let showErrorProperty = PassthroughSubject<String, Never>()
    public func showError() -> PassthroughSubject<String, Never> {
        return showErrorProperty
    }
    
    private let searchControllerDidChangeActionProperty = PassthroughSubject<Bool, Never>()
    public func searchControllerDidChangeAction() -> PassthroughSubject<Bool, Never> {
        return searchControllerDidChangeActionProperty
    }
    
    // MARK: - ⚙️ Helpers
    private func handleNetworkResponseError(_ networkResponse: NetworkResponse) {
        print("❌ Network response error: \(networkResponse.localizedDescription)")
        self.showErrorProperty.send("Network response error.")
    }

    // MARK: - 🗑 Deinit
    deinit {
        print("🗑", "EventsVM deinit.")
    }
}

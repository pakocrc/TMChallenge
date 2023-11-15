//
//  EventsViewModelTests.swift
//  TMChallengeTests
//
//  Created by Francisco Jose Cordoba Rojas on 15/11/23.
//

import Combine
import TMChallenge
import XCTest

final class EventsViewModelTests: XCTestCase {
    var viewModel: EventsViewModel?
    var subscriptions = Set<AnyCancellable>()
    var fetchEventsSubscription: Cancellable?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testSearchControllerDidChange() {
        let ex = XCTestExpectation()
        configure()
        
        viewModel?.outputs.searchControllerDidChangeAction()
            .sink(receiveValue: { _ in
                ex.fulfill()
            }).store(in: &subscriptions)
        
        viewModel?.inputs.searchControllerDidChange(isActive: true)
        viewModel?.inputs.searchControllerDidChange(isActive: false)
        
        wait(for: [ex], timeout: 1)
    }
    
    func testLoading() {
        let ex = XCTestExpectation()
        configure()
        
        viewModel?.outputs.loading()
            .sink(receiveValue: { _ in
                ex.fulfill()
            }).store(in: &subscriptions)
        
        viewModel?.inputs.fetchEvents()
        
        wait(for: [ex], timeout: 1)
    }
    
    func testFetchEventsSuccess() {
        configure()
        var newEvents = [EventTM]()
        viewModel?.inputs.fetchEvents()
        
        viewModel?.outputs.fetchEventsAction()
            .filter({ !($0?.isEmpty ?? true) })
            .sink(receiveValue: { events in
                guard let events = events else { return }
                newEvents = events
            }).store(in: &subscriptions)
        
        viewModel?.inputs.fetchEvents()
        
        XCTAssertNotNil(newEvents)
    }
    
    func testFetchEventsFail() {
        var newError = ""
        configure()
        viewModel?.page = 1
      
        viewModel?.outputs.showError()
            .filter({ !($0.isEmpty) })
            .sink(receiveValue: { error in
                newError = error
            }).store(in: &subscriptions)
        
        viewModel?.inputs.fetchEvents()

        XCTAssertEqual(newError, "Network response error.")
    }
    
    func testSearchEventsSuccess() {
        configure()
        var newEvents = [EventTM]()
        
        viewModel?.outputs.fetchEventsAction()
            .filter({ !($0?.isEmpty ?? true) })
            .sink(receiveValue: { events in
                guard let events = events, !events.isEmpty else { return }
                newEvents = events
            }).store(in: &subscriptions)
        
        viewModel?.inputs.searchTextDidChange(searchQuery: "Disney")
        
        XCTAssertNotNil(newEvents)
    }
    
    func testSearchEventsFail() {
        var newError = ""
        configure()
      
        viewModel?.outputs.showError()
            .filter({ !($0.isEmpty) })
            .sink(receiveValue: { error in
                newError = error
            }).store(in: &subscriptions)
        
        viewModel?.inputs.searchTextDidChange(searchQuery: "Disne")

        XCTAssertEqual(newError, "Network response error.")
    }
    
    private func configure() {
        let service = EventsService(eventsNetworkService: EventsNetworkServiceMock())
        self.viewModel = EventsViewModel(eventsService: service)
    }
}

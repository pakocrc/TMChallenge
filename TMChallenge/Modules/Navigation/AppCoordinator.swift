//
//  AppCoordinator.swift
//  TMTest
//
//  Created by Francisco Jose Cordoba Rojas on 13/11/23.
//

import Foundation
import UIKit
import Combine

protocol Coordinator {
    func start()
}

final class AppCoordinator: Coordinator {
    // MARK: Consts
    private let parentViewController: BaseViewController
//    private let eventsService: EventsService
    
    // MARK: Vars
    private var window: UIWindow
    private var cancellable = Set<AnyCancellable>()
    
    init(window: UIWindow) {
        self.parentViewController = BaseViewController()

        self.window = window
        self.window.rootViewController = parentViewController
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        let mainNavigation = UINavigationController()
        
        let eventsService = EventsService(eventsNetworkService: EventsNetworkService())
        let eventsVM = EventsViewModel(eventsService: eventsService)
        let eventsVC = EventsViewController(viewModel: eventsVM)
        
        mainNavigation.addChild(eventsVC)
        
        parentViewController.addChild(mainNavigation)
        parentViewController.view.addSubview(mainNavigation.view)
        mainNavigation.didMove(toParent: parentViewController)
    }
}

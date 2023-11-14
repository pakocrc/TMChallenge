//
//  EventsViewController.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 13/11/23.
//

import Combine
import UIKit

final class EventsViewController: BaseViewController {
    // MARK: Consts
    let viewModel: EventsViewModel
    
    // MARK: UI Elements
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.isActive = true
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    private lazy var myButton: UIButton = {
        let myButton = UIButton(type: .system)
        myButton.setTitle("Reload", for: .normal)
        myButton.frame = CGRect(x: 100, y: 100, width: 200, height: 40)
        myButton.translatesAutoresizingMaskIntoConstraints = false
        myButton.addTarget(self, action: #selector(fetchEvents), for: .touchUpInside)

        return myButton
    }()
    
    init(viewModel: EventsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "Simple TM Event List"
        navigationItem.searchController = searchController
    }
    
    override func setupUI() {
        super.setupUI()
        view.addSubview(myButton)
        
        NSLayoutConstraint.activate([
            myButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            myButton.widthAnchor.constraint(equalToConstant: 200),
            myButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc
    func fetchEvents() {
        viewModel.inputs.fetchEvents()
    }
}

extension EventsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.showsSearchResultsController = true

//        if currentSearchControllerStatus != searchController.isActive {
//            self.currentSearchControllerStatus = searchController.isActive
//            viewModel.inputs.searchControllerDidChange(isActive: searchController.isActive)
//        }
//
//        if let searchQuery = searchController.searchBar.text {
//            viewModel.inputs.searchTextDidChange(searchQuery: searchQuery)
//
//            if !searchQuery.isEmpty, searchQuery.count >= 4 {
//                DispatchQueue.main.async { [weak self] in
//                    self?.searchController.searchBar.isLoading = true
//                }
//            }
//        }
    }
}

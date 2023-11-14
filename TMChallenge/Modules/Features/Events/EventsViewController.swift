//
//  EventsViewController.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 13/11/23.
//

import Combine
import UIKit

final class EventsViewController: EventsBaseCollectionView {
    // MARK: Consts
    let viewModel: EventsViewModel
    
    // MARK: Subscriptions
    private var finishedFetchingSubscription: Cancellable?
    private var fetchEventsSubscription: Cancellable?
    private var searchCriteriaSubscription: Cancellable?
    private var loadingSubscription: Cancellable?
    private var showErrorSubscription: Cancellable?
    private var viewtitleSubscription: Cancellable?
    
    // MARK: UI Elements
    private lazy var sizeMenu: UIMenu = { [unowned self] in
        let menu = UIMenu(title: NSLocalizedString("collection_view_set_size_menu_title", comment: "Select items size"), image: nil, identifier: nil, options: [.displayInline], children: [
            UIAction(title: NSLocalizedString("columns", comment: "Columns"), image: UIImage(systemName: "rectangle.split.3x1"), handler: { (_) in
                self.collectionLayout = .columns
            }),
            UIAction(title: NSLocalizedString("list", comment: "List"), image: UIImage(systemName: "square.fill.text.grid.1x2"), handler: { (_) in
                self.collectionLayout = .list
            })
        ])

        return menu
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.isActive = true
        searchController.searchResultsUpdater = self
        return searchController
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
        setupNavigationBar()
        collectionView.delegate = self
        viewModel.inputs.fetchEvents()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "Simple TM Event List"
        navigationItem.searchController = searchController
        
        let leftBarButtonImage = UIImage(systemName: "square.fill.text.grid.1x2")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("collection_view_set_layout_button_title", comment: "Set collection layout"), image: leftBarButtonImage, primaryAction: nil, menu: sizeMenu)
    }
    
    override func bindViewModel() {
        fetchEventsSubscription = viewModel.outputs.fetchEventsAction()
            .filter({ !($0?.isEmpty ?? true) })
            .sink(receiveValue: { [weak self] (events) in
                guard let events = events, !events.isEmpty else { return }

                DispatchQueue.main.async { [weak self] in
                    self?.navigationController?.navigationItem.rightBarButtonItem?.isEnabled = true
                    self?.updateDataSource(events: events)
                }
            })

        loadingSubscription = viewModel.outputs.loading()
            .sink(receiveValue: { [weak self] (loading) in
                guard let `self` = self else { return }
                self.loading = loading
            })

        finishedFetchingSubscription = viewModel.outputs.finishedFetchingAction()
            .sink(receiveValue: { [weak self] (finishedFetching) in
                guard let `self` = self else { return }
                self.finishedFetching = finishedFetching
            })

        showErrorSubscription = viewModel.outputs.showError()
            .sink(receiveValue: { [weak self] errorMessage in
                guard let `self` = self else { return }
                self.handleEmptyView()
                Alert.showAlert(on: self, title: "Something went wrong", message: errorMessage)
            })
    }
    
    // MARK: - Collection View
    override func updateDataSource(events: [EventTM], animatingDifferences: Bool = true) {
            var snapshot = self.dataSource.snapshot()

            snapshot.appendItems(events, toSection: .events)
            self.loadedCount = snapshot.numberOfItems

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let `self` = self else { return }

            self.collectionView.removeEmptyView()
            self.setActivityIndicator(active: false)
            self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard loadedCount != 0 else { return }

        self.footerContentView.isHidden = indexPath.row <= loadedCount - 6

        if indexPath.row == loadedCount - 1 {
            if !finishedFetching {
                self.setActivityIndicator(active: true)
                self.viewModel.inputs.fetchEvents()
            }
        }
    }

    override func handleEmptyView() {
        let dataSourceItems = dataSource.snapshot().numberOfItems

        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            if self.loading && dataSourceItems < 1 {
                self.collectionView.setEmptyView(title: "Loading...",
                                                 message: "Please wait...",
                                                 centeredY: true)

            } else if !self.loading && dataSourceItems < 1 {
                self.collectionView.setEmptyView(title: "Empty list",
                                                 message: "Empty list",
                                                 centeredY: true)

                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.reloadCollectionView))
                tapGestureRecognizer.numberOfTapsRequired = 1

                self.collectionView.backgroundView?.isUserInteractionEnabled = true

                self.collectionView.backgroundView?.addGestureRecognizer(tapGestureRecognizer)

            } else {
                self.collectionView.removeEmptyView()
            }
        }
    }
    
    // MARK: - ⚙️ Helpers
    @objc
    private func reloadCollectionView() {
        viewModel.inputs.fetchEvents()
        handleEmptyView()
    }

    // MARK: - 🗑 Deinit
    deinit {
        print("🗑 EventsViewController deinit.")
    }
}

extension EventsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let event = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.inputs.eventSelected(event: event)
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

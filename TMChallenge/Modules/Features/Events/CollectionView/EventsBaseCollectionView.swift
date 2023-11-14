//
//  EventsBaseCollectionView.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 14/11/23.
//

import Foundation
import UIKit

enum CollectionLayout: CGFloat {
    case list         = 1.0
    case columns     = 0.33333
}

class EventsBaseCollectionView: BaseViewController {
    enum Section: CaseIterable {
        case events
    }

    // MARK: - Types
    typealias DataSource = UICollectionViewDiffableDataSource<Section, EventTM>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, EventTM>

    // MARK: - Variables
    var collectionView: UICollectionView!
    var dataSource: DataSource!
    var loadedCount = 0
    var loading = false

    var finishedFetching = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.footerLabel.isHidden = !self.finishedFetching
                if self.finishedFetching {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    var collectionLayout: CollectionLayout = .columns {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }

                var buttonImage: UIImage?
                switch self.collectionLayout {
                case .list:
                    buttonImage = UIImage(systemName: "rectangle.split.3x1")
                case .columns:
                    buttonImage = UIImage(systemName: "square.fill.text.grid.1x2")
                }

                self.navigationItem.leftBarButtonItem?.image = buttonImage
                self.collectionView.setCollectionViewLayout(self.createLayout(), animated: true)
            }
        }
    }

    // MARK: - UI Elements
    let footerContentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = UIColor.gray
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let footerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "End of the list"
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        configureDataSource()
        setInitialData()

        view.backgroundColor = .systemBackground

        footerContentView.addSubview(footerLabel)
        footerContentView.addSubview(activityIndicator)

        view.addSubview(collectionView)
        view.addSubview(footerContentView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            footerContentView.heightAnchor.constraint(equalToConstant: 40.0),
            footerContentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            footerContentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            footerContentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            activityIndicator.heightAnchor.constraint(equalToConstant: 40.0),
            activityIndicator.widthAnchor.constraint(equalTo: footerContentView.widthAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: footerContentView.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: footerContentView.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            footerLabel.centerXAnchor.constraint(equalTo: footerContentView.centerXAnchor),
            footerLabel.widthAnchor.constraint(equalTo: footerContentView.widthAnchor),
            footerLabel.heightAnchor.constraint(equalToConstant: 45.0),
            footerLabel.bottomAnchor.constraint(equalTo: footerContentView.bottomAnchor)
        ])
    }

    override func didReceiveMemoryWarning() {
        print("⚠️ Memory Warning on EventsBaseCollectionView")
        cache.removeAllValues()
    }

    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: EventCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.alwaysBounceVertical = false
        collectionView.contentInset.bottom = 50
        collectionView.backgroundColor = .clear
    }

    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth((self.collectionLayout == .columns && UIDevice.isLandscape) ? 0.25 : self.collectionLayout.rawValue), heightDimension: .fractionalHeight(1.0))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.uniform(size: 2.0)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.5))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<EventCollectionViewCell, EventTM> { cell, _, event in
            cell.configure(with: event)
        }

        let dataSource = UICollectionViewDiffableDataSource<Section, EventTM>(collectionView: collectionView) { (collectionView, indexPath, event) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: event)
        }

        self.dataSource = dataSource
    }

    func setInitialData() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections(Section.allCases)
        self.dataSource.apply(snapshot, animatingDifferences: false)
        self.handleEmptyView()
    }

    func reloadDataSource() {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(Section.allCases)

        self.dataSource.apply(snapshot, animatingDifferences: true)
    }

    func updateDataSource(events: [EventTM], animatingDifferences: Bool = true) {
        preconditionFailure("Override updateDataSource() to update the datasource")
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        preconditionFailure("Override willDisplay")
    }

    func handleEmptyView() {
        preconditionFailure("Override handleEmptyView() to provide an empty view for the collection view")
    }

    func setActivityIndicator(active: Bool) {
        _ = active ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}

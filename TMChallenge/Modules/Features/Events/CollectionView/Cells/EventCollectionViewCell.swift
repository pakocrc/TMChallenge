//
//  EventCollectionViewCell.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 14/11/23.
//

import UIKit

final class EventCollectionViewCell: UICollectionViewCell {
    
    // MARK: Constants
    static let reuseIdentifier = "eventCollectionViewCellId"
    
    // MARK: Variables
    private var eventImageWidthAnchor: NSLayoutConstraint?
    private var eventImageLeadingAnchor: NSLayoutConstraint?
    private var eventImageCenterXAnchor: NSLayoutConstraint?

    private var eventTitleLeadingAnchor: NSLayoutConstraint?
    private var eventOverviewLeadingAnchor: NSLayoutConstraint?

    private var event: EventTM? {
        didSet {
            guard let event = event else { return }

            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                
                if let posterPath = event.images.first {
                    self.eventImage.setUrlString(urlString: posterPath.url)
                }
                
                self.eventTitle.text = !event.name.isEmpty ? event.name : ""
                self.eventOverview.text = "\(event.eventEmbedded.venues.first?.name ?? ""), \(event.eventEmbedded.venues.first?.address.name ?? ""), \(event.eventEmbedded.venues.first?.state.name ?? ""), \(event.eventEmbedded.venues.first?.country.name ?? "")"
                
                self.releaseDateLabel.text = !event.dates.start.localDate.isEmpty ? event.dates.start.localDate : ""
            }
        }
    }

    override func layoutSubviews() {
        if 0...(UIScreen.main.bounds.width / 3) ~= frame.width { // Columns
            self.handleCellLayoutChange(collectionLayout: .columns)

        } else if 0...(UIScreen.main.bounds.width) ~= frame.width { // List
            self.handleCellLayoutChange(collectionLayout: .list)
        }

        super.layoutSubviews()
    }

    // MARK: UI Elements
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.alpha = 0.4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let eventImage = CustomEventImage()

    private let eventTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3) // .bold()
        label.adjustsFontForContentSizeCategory = true
        label.maximumContentSizeCategory = .accessibilityMedium
        label.numberOfLines = 2
        label.setContentCompressionResistancePriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.sizeToFit()
        return label
    }()

    private let eventOverview = CustomTextView()

    private let subHeaderStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let releaseDateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textAlignment = .natural
        label.maximumContentSizeCategory = .accessibilityMedium
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.text = ""
        label.textColor = UIColor.darkGray
        label.sizeToFit()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCellView() {
        addSubview(eventImage)

        eventImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        eventImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        eventImageWidthAnchor = eventImage.widthAnchor.constraint(equalToConstant: frame.width)
        eventImageCenterXAnchor = eventImage.centerXAnchor.constraint(equalTo: centerXAnchor)
        eventImageLeadingAnchor = eventImage.leadingAnchor.constraint(equalTo: leadingAnchor)

        eventImageWidthAnchor?.isActive = true
        eventImageLeadingAnchor?.isActive = false
        eventImageCenterXAnchor?.isActive = true
    }

    // MARK: Helpers
    func configure(with data: EventTM?) {
        self.event = data
    }

    private func handleCellLayoutChange(collectionLayout: CollectionLayout) {
        switch collectionLayout {
            case .list:

            eventImageWidthAnchor?.constant = frame.width * 0.25
            eventImageCenterXAnchor?.isActive = false
            eventImageLeadingAnchor?.isActive = true
            eventImage.contentMode = .scaleAspectFit

            subHeaderStack.addArrangedSubview(releaseDateLabel)

            addSubview(separatorView)
            addSubview(eventTitle)
            addSubview(subHeaderStack)
            addSubview(eventOverview)

            separatorView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true

            eventTitle.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10).isActive = true
            eventTitle.leadingAnchor.constraint(equalTo: eventImage.trailingAnchor, constant: 10).isActive = true
            eventTitle.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
            eventTitle.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true

            subHeaderStack.topAnchor.constraint(equalTo: eventTitle.bottomAnchor, constant: 0).isActive = true
            subHeaderStack.leadingAnchor.constraint(equalTo: eventImage.trailingAnchor, constant: 10).isActive = true
            subHeaderStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
            subHeaderStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true

            eventOverview.topAnchor.constraint(equalTo: subHeaderStack.bottomAnchor).isActive = true
            eventOverview.leadingAnchor.constraint(equalTo: eventImage.trailingAnchor, constant: 10).isActive = true
            eventOverview.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
            eventOverview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
            eventOverview.isUserInteractionEnabled = false

            case .columns:
            separatorView.removeFromSuperview()
            eventTitle.removeFromSuperview()
            releaseDateLabel.removeFromSuperview()
            subHeaderStack.removeFromSuperview()
            eventOverview.removeFromSuperview()

            eventImageWidthAnchor?.constant = frame.width
            eventImageCenterXAnchor?.isActive = true
            eventImageLeadingAnchor?.isActive = false
            eventImage.contentMode = .scaleAspectFill
        }
    }

    // MARK: - 🗑 Deinit
    deinit {
//        print("🗑 EventCollectionViewCell deinit.")
    }
    
}

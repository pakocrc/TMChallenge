//
//  CustomEventImage.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 14/11/23.
//

import UIKit

final class CustomEventImage: UIImageView {
    // MARK: - Constants
    private let resetImage: Bool

    // MARK: - Variables
//    var posterSize = UIDevice.current.isIpad ? ".w780" : "PosterSize.w342"

    private var urlString: String? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self, let urlString = self.urlString else { return }

                if let cacheImage = cache.value(forKey: "\(urlString)") {
                    self.image = cacheImage
                    self.activityIndicatorView.stopAnimating()

                } else {
                    if self.resetImage {
                        self.image = UIImage(named: "no_poster")
                    }

                    self.activityIndicatorView.startAnimating()

                    ImageService.shared().getImage(imagePath: urlString) { data, _ in

                        DispatchQueue.main.async { [weak self] in
                            guard let `self` = self else { return }
                            self.activityIndicatorView.stopAnimating()

                            guard let data = data else { return }

                            if let newImage = UIImage(data: data) {
                                self.image = newImage
                                cache.insert(newImage, forKey: "\(urlString)")
                            }
                        }
                    }
                }
            }
        }
    }

    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = UIColor.gray
        return activityIndicator
    }()

    init(resetImage: Bool = true) {
        self.resetImage = resetImage
        super.init(frame: .zero)
        setupView()
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        contentMode = .scaleAspectFill
        sizeToFit()
        image = UIImage(named: "no_poster")

        addSubview(activityIndicatorView)

        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUrlString(urlString: String) {
        self.urlString = urlString
    }
}

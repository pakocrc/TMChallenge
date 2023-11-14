//
//  ImageService.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 14/11/23.
//

import Foundation

public final class ImageService: ImageNetworkServiceProtocol {
    private let imageNetworkService: ImageNetworkService

    private static let sharedImageService: ImageService = {
        return ImageService(imageNetworkService: ImageNetworkService())
    }()

    private init(imageNetworkService: ImageNetworkService) {
        self.imageNetworkService = imageNetworkService
    }

    static func shared() -> ImageService {
        return sharedImageService
    }

    /// Use this method to get images
    /// - Parameters:
    ///   - imagePath: The image path
    ///   - completion: The callback
    public func getImage(imagePath: String, completion: @escaping (Data?, NetworkResponse?) -> Void) {
        self.getImageApi(imagePath: imagePath) { data, networkResponseApi in
            var networkResponse: NetworkResponse
            switch networkResponseApi {
            case .success(let msg): networkResponse = .success(msg)
            case .authenticationError: networkResponse = .authenticationError
            case .badRequest: networkResponse = .badRequest
            case .outdated: networkResponse = .outdated
            case .failed(let error): networkResponse = .failed(error)
            case .noData: networkResponse = .noData
            case .unableToDecode: networkResponse = .unableToDecode
            case .none: networkResponse = .noData
            }

            completion(data, networkResponse)
        }
    }

    // MARK: - Network Service
    public func getImageApi(imagePath: String, completion: @escaping (Data?, NetworkResponseApi?) -> Void) {
        return imageNetworkService.getImageApi(imagePath: imagePath, completion: completion)
    }
}

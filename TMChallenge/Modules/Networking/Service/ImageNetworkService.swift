//
//  ImageNetworkService.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 14/11/23.
//

import Foundation

public protocol ImageNetworkServiceProtocol {
    func getImageApi(imagePath: String, completion: @escaping (_ imageData: Data?, _ error: NetworkResponseApi?) -> Void)
}

public final class ImageNetworkService: ImageNetworkServiceProtocol {
    private let networkManager = NetworkManager<ImageApiEndpoint>()
    
    public init() {
        
    }
    
    public func getImageApi(imagePath: String, completion: @escaping (_ imageData: Data?, _ error: NetworkResponseApi?) -> Void) {
        networkManager.request(.image(imagePath: imagePath)) { [weak self] data, response, error in
            guard let `self` = self else { return }
            
            if error != nil {
                let errorMessage = error?.localizedDescription ?? ""
                print("🔴 [ImageNetworkService] [getImage] An error occurred: \(errorMessage)")
                completion(nil, NetworkResponseApi.failed(errorMessage))
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.networkManager.handleNetworkResponse(response)
                switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(nil, NetworkResponseApi.noData)
                            return
                        }
                        completion(responseData, nil)
                    case .failure(let networkFailureError):
                        print("🔴 [ImageNetworkService] [getImageApi] An error occurred: \(networkFailureError)")
                        completion(nil, NetworkResponseApi.failed(networkFailureError.localizedDescription))
                }
            }
        }
    }
}

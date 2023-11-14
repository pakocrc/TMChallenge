//
//  Alert.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 14/11/23.
//

import UIKit

struct Alert {
    private static func showBasicAlert(on viewController: UIViewController, with title: String, message: String, actions: [UIAlertAction]) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            actions.forEach { alert.addAction($0) }
            viewController.present(alert, animated: true)
        }
    }
    
    static func showAlert(on viewController: UIViewController, title: String, message: String) {
        var actions: [UIAlertAction] = []
        actions.append(UIAlertAction(title: "Close button", style: .default, handler: { _ in }))
        showBasicAlert(on: viewController, with: title, message: message, actions: actions)
    }
}

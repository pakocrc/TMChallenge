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
    
    /// Present an basic alert on the center of the screen.
    /// - Parameters:
    ///     - viewController: The view controller to be presented in.
    ///     - message: A message for the alert.
    ///     - title: A title for the alert.
    static func showAlert(on viewController: UIViewController, title: String, message: String) {
        var actions: [UIAlertAction] = []
        actions.append(UIAlertAction(title: NSLocalizedString("close", comment: "Close button"), style: .default, handler: { _ in }))
        showBasicAlert(on: viewController, with: title, message: message, actions: actions)
    }
}

//
//  UIDevice.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 14/11/23.
//

import UIKit

extension UIDevice {
    static var isLandscape: Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

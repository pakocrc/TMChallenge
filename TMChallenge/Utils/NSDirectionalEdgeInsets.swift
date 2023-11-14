//
//  NSDirectionalEdgeInsets.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 14/11/23.
//

import Foundation
import UIKit

extension NSDirectionalEdgeInsets {
    static func uniform(size: CGFloat) -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: size, leading: size, bottom: size, trailing: size)
    }

    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }

    init(header: CGFloat) {
        self.init(top: header, leading: header, bottom: .zero, trailing: .zero)
    }

    static func small() -> NSDirectionalEdgeInsets {
        return .uniform(size: 5)
    }

    static func medium() -> NSDirectionalEdgeInsets {
        return .uniform(size: 10)
    }

    static func large() -> NSDirectionalEdgeInsets {
        return .uniform(size: 20)
    }
}

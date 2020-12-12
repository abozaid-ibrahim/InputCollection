//
//  UICollectionView+Cell.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 11.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

public extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

public extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }

    func dequeue<T: UICollectionViewCell>(cell: T.Type, for indexPath: IndexPath) -> T {
        let collectionCell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath)
        guard let cell = collectionCell as? T else {
            fatalError("Failed to cast cell to \(T.identifier)")
        }
        return cell
    }
}

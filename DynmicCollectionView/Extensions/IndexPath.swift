//
//  IndexPath.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 06.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
extension Array where Element == Int {
    var asIndexPaths: [IndexPath] {
        return map { IndexPath(row: $0, section: 0) }
    }
}

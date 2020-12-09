//
//  IndexPath.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 06.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

extension IndexPath {
    init(position: Int) {
        self.init(row: position, section: 0)
    }
}

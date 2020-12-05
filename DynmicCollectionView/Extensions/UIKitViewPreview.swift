//
//  UIKitPreview.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 04.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

import SwiftUI
import UIKit

struct UIKitViewPreview: UIViewRepresentable {
    let view: UIView
    init(view: UIView) {
        self.view = view
    }

    func makeUIView(context: Context) -> UIView {
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

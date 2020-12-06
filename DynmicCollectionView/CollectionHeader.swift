//
//  CollectionHeader.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 04.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
final class CollectionHeader: UIView {
    static let identifier = "CollectionHeader"

    var items: [String] = []
    lazy var contentContainer: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 1
        return stack
    }()

    private func newTitleLabel(with title: String) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.text = title
        if #available(iOS 13.0, *) {
            label.textColor = .label
        } else {
            label.textColor = .black
        }
        return label
    }

    private func setup() {
        if #available(iOS 13.0, *) {
            backgroundColor = .systemGray6
        } else {
            backgroundColor = .gray
        }
        addSubview(contentContainer)
        contentContainer.setConstrainsEqualToParentEdges()
        for string in items {
            let label = newTitleLabel(with: string)
            contentContainer.addArrangedSubview(label)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    init(with items: [String]) {
        self.items = items
        super.init(frame: UIScreen.main.bounds)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@available(iOS 13.0.0, *)
struct Test_Preview: PreviewProvider {
    static var previews: some View {
        return Group {
            UIKitViewPreview(view: CollectionHeader(with: ["Helo", "ADS", "asf"]))
        }
    }
}

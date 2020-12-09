//
//  InputCollectionHeader.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 04.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

protocol InputCollectionHeaderType {
}

final class InputCollectionHeader: UIView, InputCollectionHeaderType {
    static let identifier = "InputCollectionHeader"
    let doubleClick: Observable<Bool> = .init(false)
    var items: [String] = []

    lazy private var contentContainer: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()

    private let widthConstrainID = "width"
    private func newTitleLabel(with title: String) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        let const = label.widthAnchor.constraint(equalToConstant: bounds.width / 3)
        const.identifier = widthConstrainID
        const.isActive = true
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
        for index in 0 ..< items.count {
            let label = newTitleLabel(with: items[index])
            contentContainer.addArrangedSubview(label)
        }
        enableDoubleTap()
    }

    func updateLabelsWidth(with widths: [CGFloat]) {
        var index = 0
        for label in contentContainer.arrangedSubviews {
            guard let widthConstrain = label.constraints.first(where: { $0.identifier == widthConstrainID }) else {
                continue
            }
            widthConstrain.constant = widths[index]
            index += 1
        }
        layoutIfNeeded()
    }

    private func enableDoubleTap() {
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        addGestureRecognizer(doubleTapRecognizer)
    }

    @objc private func didDoubleTap(_ sender: UITapGestureRecognizer) {
        doubleClick.next(true)
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
            UIKitViewPreview(view: InputCollectionHeader(with: ["Helo", "ADS", "asf"]))
        }
    }
}

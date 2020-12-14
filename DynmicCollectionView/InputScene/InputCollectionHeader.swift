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

protocol InputCollectionHeaderView: UIView {
    init(with items: [String], onSelected: ItemSelectedEvent?)
    func updateLabelsWidth(with widths: [CGFloat])
}

typealias ItemSelectedEvent = (Int) -> Void
final class InputCollectionHeader: UIView, InputCollectionHeaderView {
    private let widthConstrainID = "width"
    private let spacing: CGFloat = 1
    private var selectedEvent: ItemSelectedEvent?
    private var items: [String] = []

    private lazy var contentContainer: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = spacing
        return stack
    }()

    private lazy var emptyHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private func newTitleLabel(with title: String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        let widthConstrain = label.widthAnchor.constraint(equalToConstant: (bounds.width / CGFloat(items.count)) )
        widthConstrain.identifier = widthConstrainID
        widthConstrain.isActive = true
        label.backgroundColor = UIColor.brown.withAlphaComponent(0.2)
        label.layer.borderWidth = spacing
        label.layer.borderColor = UIColor.themeLightGray.cgColor

        return label
    }

    private func setup() {
        addSubview(contentContainer)
        contentContainer.setConstrainsEqualToParentEdges()
        for index in 0 ..< items.count {
            let label = newTitleLabel(with: items[index])
            label.tag = index
            enableDoubleTap(for: label)
            contentContainer.addArrangedSubview(label)
        }
        contentContainer.addArrangedSubview(emptyHeaderView)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 40).isActive = true
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
    }

    private func enableDoubleTap(for label: UILabel) {
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        label.addGestureRecognizer(doubleTapRecognizer)
    }

    @objc private func didDoubleTap(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        selectedEvent?(index)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    init(with items: [String], onSelected: ItemSelectedEvent?) {
        self.items = items
        selectedEvent = onSelected
        super.init(frame: UIScreen.main.bounds)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

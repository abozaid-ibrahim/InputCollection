//
//  EditableCollectionCell.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 04.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import SwiftUI
import UIKit

final class EditableCollectionCell: UICollectionViewCell {
    static let reuseIdentifier = "EditableCollectionCellID"
    lazy var textView1: UITextView = {
        buildTextView()
    }()

    lazy var textView2: UITextView = {
        buildTextView()
    }()

    lazy var textView3: UITextView = {
        buildTextView()
    }()

    lazy var contentContainer: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 1
        return stack
    }()

    private func buildTextView() -> UITextView {
        let view = UITextView()
        view.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.text = "asdfasfkajd"
        view.textAlignment = .center
//        view.sizeToFit()
        view.isScrollEnabled = false
        return view
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        contentView.backgroundColor = .systemGray4
        contentView.addSubview(contentContainer)
        contentContainer.setConstrainsEqualToParentEdges(top: 2, bottom: 2, leading: 2, trailing: 2)
        contentContainer.addArrangedSubview(textView1)
        contentContainer.addArrangedSubview(textView2)
        contentContainer.addArrangedSubview(textView3)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@available(iOS 13.0.0, *)
struct Cell_Preview: PreviewProvider {
    static var previews: some View {
        return Group {
            UIKitViewPreview(view: EditableCollectionCell(frame: UIScreen.main.bounds))
        }
    }
}

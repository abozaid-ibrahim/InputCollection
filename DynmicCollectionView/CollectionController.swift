//
//  CollectionController.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 04.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import SwiftUI
import UIKit

final class CollectionController: UIViewController {
    var items: [String] = ["a", "b", "c"]

    var heights: [[CGFloat]] = [[33, 44, 4]]
     var currentEditingIndex = -1

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()

    lazy var headerView: CollectionHeader = {
        let view = CollectionHeader(with: ["Name", "Title", "Description"])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()

    lazy var contentContainer: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.distribution = .fill
        stack.axis = .vertical
        stack.addArrangedSubview(self.headerView)
        stack.addArrangedSubview(self.collectionView)
        return stack
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("no implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        collectionView.register(EditableCollectionCell.self,
                                forCellWithReuseIdentifier: EditableCollectionCell.reuseIdentifier)
        collectionView.backgroundColor = .brown
        collectionView.reloadData()
    }

    private func setup() {
        view.addSubview(contentContainer)
        contentContainer.setConstrainsEqualToParentEdges()
    }
}

extension CollectionController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let index = textView.tag
        currentEditingIndex = index

        items[index] = textView.text
        let section = index / 3
        let column = index % 3
        if heights[section][column] != newSize.height {
            heights[section][column] = newSize.height
            let items = [IndexPath(row: section, section: 0), IndexPath(row: section + 1, section: 0), IndexPath(row: section + 2, section: 0)]
            UIView.performWithoutAnimation {
                collectionView.reloadItems(at: items)
            }
        }
    }
}
@available(iOS 13.0.0, *)
struct CollectionControllerPreview: PreviewProvider {
    static var previews: some View {
        return Group {
            UIKitViewPreview(view: CollectionController().contentContainer)
        }
    }
}

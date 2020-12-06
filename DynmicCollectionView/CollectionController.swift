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
        view.doubleClick.subscribe {
            if $0 {
                HeightEditor.shared.expandAllCells(false)
                self.collectionView.reloadData()
            }
        }
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
        prepareCollection()
    }

    private func prepareCollection() {
        view.addSubview(contentContainer)
        contentContainer.setConstrainsEqualToSafeArea()
        collectionView.register(EditableCollectionCell.self,
                                forCellWithReuseIdentifier: EditableCollectionCell.reuseIdentifier)
        collectionView.backgroundColor = .brown
        collectionView.reloadData()
    }
}

extension CollectionController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.size.width,
                                                   height: CGFloat.greatestFiniteMagnitude))
        let index = textView.tag
        currentEditingIndex = index
        items[index] = textView.text
        HeightEditor.shared.set(height: newSize.height,
                                for: IndexPath(row: index, section: 0))
        reloadRow(row: index)
    }

    func reloadRow(row: Int) {
        UIView.performWithoutAnimation {
            let row = row / 3
            collectionView.reloadItems(at: [row, row + 1, row + 2].asIndexPaths)
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

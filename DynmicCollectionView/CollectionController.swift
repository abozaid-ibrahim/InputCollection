//
//  CollectionController.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 04.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit
import SwiftUI

final class CollectionController: UIViewController {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
//        collection.collectionViewLayout = layout
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()

    lazy var headerView: CollectionHeader = {
        let view = CollectionHeader(with: ["aaaa","adas","asedfa"])
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        collectionView.register(EditableCollectionCell.self,
                                forCellWithReuseIdentifier: EditableCollectionCell.reuseIdentifier)
        collectionView.register(CollectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CollectionHeader.identifier)
        collectionView.backgroundColor = .brown
        collectionView.reloadData()
    }

    private func setup() {
        view.addSubview(contentContainer)
        contentContainer.setConstrainsEqualToParentEdges()
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

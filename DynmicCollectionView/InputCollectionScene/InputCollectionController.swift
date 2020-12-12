//
//  InputCollectionController.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 04.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import SwiftUI
import UIKit

final class InputCollectionController: UIViewController {
    let viewModel: InputViewModelType
    private(set) lazy var measures = CollectionMeasures(screenWidth: self.collectionView.bounds.width)
    private(set) lazy var animator = ResizeAnimator(collectionView: self.collectionView, measures: measures)

    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()

    private(set) lazy var headerView: InputCollectionHeader = {
        let view = InputCollectionHeader(with: [.name, .title, .notes])
        view.doubleClick.subscribe { [weak self] in
            guard let self = self,
                  $0 >= 0 else { return }
            self.measures.squeezeColumn(of: $0, squeeze: true)
            self.headerView.updateLabelsWidth(with: self.measures.columnWidths)
            self.collectionView.reloadData()
        }
        return view
    }()

    private lazy var contentContainer: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.distribution = .fill
        stack.axis = .vertical
        stack.addArrangedSubview(self.headerView)
        stack.addArrangedSubview(self.collectionView)
        return stack
    }()

    init(with viewModel: InputViewModelType = InputViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("no implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollection()
        title = .sapCollection
        navigationItem.rightBarButtonItem = .init(title: .add,
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(addRow(_:)))
        addNewRow()
    }

    @objc private func addRow(_ sender: Any) {
        view.endEditing(true)
        addNewRow()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headerView.updateLabelsWidth(with: measures.columnWidths)
    }

    private func addNewRow() {
        viewModel.appendNewRow()
        measures.insertRow()
        collectionView.reloadData()
    }

    private func prepareCollection() {
        view.addSubview(contentContainer)
        contentContainer.setConstrainsEqualToSafeArea()
        collectionView.register(InputCollectionCell.self)
        collectionView.register(DeleteCell.self)
        collectionView.backgroundColor = .clear
        view.backgroundColor = .themeLightGray
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        measures.update(screenWidth: size.width)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension String {
    static var add: String { return "Add" }
    static var name: String { return "Name" }
    static var title: String { return "Title" }
    static var notes: String { return "Notes" }
    static var sapCollection: String { return "Input Collection" }
}

@available(iOS 13.0.0, *)
struct InputCollectionControllerPreview: PreviewProvider {
    static var previews: some View {
        return Group {
            UIKitViewPreview(view: InputCollectionController().view)
        }
    }
}

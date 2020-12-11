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
    let viewModel = InputViewModel()
    private(set) lazy var measures = CollectionMeasures(screenWidth: self.collectionView.bounds.width)
    private(set) lazy var animator = ResizeAnimator(collectionView: self.collectionView, measures: measures)

    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()

    private(set) lazy var headerView: InputCollectionHeader = {
        let view = InputCollectionHeader(with: ["Name", "Title", "Notes"])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
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

        title = "Sap Collection"
        navigationItem.rightBarButtonItem = .init(title: "Add",
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(addRow(_:)))
        viewModel.appendNewRow()
    }

    @objc private func addRow(_ sender: Any) {
        view.endEditing(true)
        viewModel.appendNewRow()
        measures.insertRow()
        collectionView.reloadData()
    }

    private func prepareCollection() {
        view.addSubview(contentContainer)
        contentContainer.setConstrainsEqualToSafeArea()
        collectionView.register(InputCollectionCell.self,
                                forCellWithReuseIdentifier: InputCollectionCell.reuseIdentifier)
        collectionView.register(DeleteCell.self,
                                forCellWithReuseIdentifier: DeleteCell.identifier)
        collectionView.backgroundColor = .brown
        collectionView.reloadData()
    }
}

extension InputCollectionController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.size.width,
                                                   height: CGFloat.greatestFiniteMagnitude))
        let index = textView.tag
        viewModel.currentEditingIndex = index
        viewModel.items[index] = .input(textView.text)
        guard measures.set(height: newSize.height, for: index) else { return }
        reloadRow(row: index)
    }

    func reloadRow(row: Int) {
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: measures.indexPathsInTheSameRow(for: row))
        }
    }
}

@available(iOS 13.0.0, *)
struct InputCollectionControllerPreview: PreviewProvider {
    static var previews: some View {
        return Group {
            UIKitViewPreview(view: InputCollectionController().view)
        }
    }
}

//
//  DeleteCell.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 10.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import SwiftUI
import UIKit

final class DeleteCell: UICollectionViewCell {
    static let identifier = "DeleteCell"
    private var tapEvent: DoubleTapEvent?

    private lazy var button: UIButton = {
        let view = UIButton()
        if let image = UIImage(named: "delete-icon") {
            view.setImage(image, for: .normal)
        }
        view.backgroundColor = .clear
        view.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
        return view
    }()

    func set(onTap: @escaping DoubleTapEvent) {
        tapEvent = onTap
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        tapEvent = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DeleteCell {
    func setup() {
        contentView.backgroundColor = .clear
        contentView.addSubview(button)
        button.setConstrainsEqualToParentEdges(top: 8, bottom: 8, leading: 8, trailing: 8)
    }

    @objc func didTap(_ sender: UITapGestureRecognizer) {
        tapEvent?()
    }
}

@available(iOS 13.0.0, *)
struct DeleteCellPreview: PreviewProvider {
    static var previews: some View {
        return Group {
            UIKitViewPreview(view: DeleteCell(frame: UIScreen.main.bounds))
        }
    }
}

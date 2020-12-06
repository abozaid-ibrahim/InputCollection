//
//  EditableCollectionCell.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 04.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import SwiftUI
import UIKit
typealias DoubleTapEvent = () -> Void
final class EditableCollectionCell: UICollectionViewCell {
    static let reuseIdentifier = "EditableCollectionCellID"
    private var doubleTapEvent: DoubleTapEvent?
    lazy var textView: UITextView = {
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
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.textAlignment = .center
        view.isScrollEnabled = false
        view.isEditable = true
        view.isSelectable = true
        view.addDoneButtonToKeypad()
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = false
        view.gestureRecognizers = nil
        view.isUserInteractionEnabled = true

        return view
    }

    func set(text: String, onDoubleTap: @escaping DoubleTapEvent) {
        doubleTapEvent = onDoubleTap
        textView.text = text
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        if #available(iOS 13.0, *) {
            contentView.backgroundColor = .systemGray4
        } else {
            contentView.backgroundColor = .gray
        }
        contentView.addSubview(textView)
        textView.setConstrainsEqualToParentEdges(top: 2, bottom: 2, leading: 2, trailing: 2)
//        contentContainer.addArrangedSubview(textView1)
        addDoubleTap()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func addDoubleTap() {
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.numberOfTouchesRequired = 1
        textView.addGestureRecognizer(singleTapRecognizer)

        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
//        doubleTapRecognizer.cancelsTouchesInView = true
//        doubleTapRecognizer.delegate = self
        textView.addGestureRecognizer(doubleTapRecognizer)

        singleTapRecognizer.require(toFail: doubleTapRecognizer)

        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        textView.addGestureRecognizer(pinchRecognizer)
    }

    private var lastScale: CGFloat = 1
    @objc func handlePinch(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            lastScale = 1.0
        }
        switch sender.state {
        case .began:
            lastScale = 1
        case .ended:
            let scale = 1.0 - (lastScale - sender.scale)
            layer.setAffineTransform(CGAffineTransform(scaleX: self.lastScale, y: scale))
        case .possible:
            print("changed")
        case .changed:
            print("changed")
        case .cancelled:
            print("changed")
        case .failed:
            print("changed")
        @unknown default:
            print("changed")
        }
    }

    @objc func didDoubleTap(_ sender: UITapGestureRecognizer) {
        print(">>> \(#function)")
        doubleTapEvent?()
    }

    @objc func didTap(_ sender: UITapGestureRecognizer) {
        print(">>> \(#function)")
        textView.becomeFirstResponder()
    }
}

// extension EditableCollectionCell: UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        print(">> \(gestureRecognizer) \n== \(otherGestureRecognizer)")
//        return true
//    }
// }

@available(iOS 13.0.0, *)
struct Cell_Preview: PreviewProvider {
    static var previews: some View {
        return Group {
            UIKitViewPreview(view: EditableCollectionCell(frame: UIScreen.main.bounds))
        }
    }
}

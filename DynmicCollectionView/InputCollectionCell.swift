//
//  InputCollectionCell.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 04.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import SwiftUI
import UIKit

typealias DoubleTapEvent = () -> Void
typealias PinchEvent = (UIPinchGestureRecognizer) -> Void
final class InputCollectionCell: UICollectionViewCell {
    static let reuseIdentifier = "InputCollectionCellID"
    private var pinchExpandUpdater: PinchEvent?
    private var doubleTapEvent: DoubleTapEvent?
    let reloadCell: Observable<Bool> = .init(false)

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

    func set(text: String,
             onDoubleTap: @escaping DoubleTapEvent,
             onPinch: @escaping PinchEvent) {
        doubleTapEvent = onDoubleTap
        pinchExpandUpdater = onPinch
        textView.text = text
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        doubleTapEvent = nil
        pinchExpandUpdater = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension InputCollectionCell {
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
        singleTapRecognizer.require(toFail: pinchRecognizer)
    }

    @objc func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        print("Order>>1 ")
        pinchExpandUpdater?(recognizer)
        switch recognizer.state {
        case .ended:
            reloadCell.next(true)
        default:
            print("")
        }
        recognizer.scale = 1.0
        print("Order>>4 ")
    }

    @objc func didDoubleTap(_ sender: UITapGestureRecognizer) {
        doubleTapEvent?()
    }

    @objc func didTap(_ sender: UITapGestureRecognizer) {
        textView.becomeFirstResponder()
    }
}

@available(iOS 13.0.0, *)
struct InputCollectionCellPreview: PreviewProvider {
    static var previews: some View {
        return Group {
            UIKitViewPreview(view: InputCollectionCell(frame: UIScreen.main.bounds))
        }
    }
}

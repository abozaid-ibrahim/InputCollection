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
typealias TextChangedEvent = ((text: String, fitHeight: CGFloat)) -> Void

final class InputCollectionCell: UICollectionViewCell {
    private var pinchExpandUpdater: PinchEvent?
    private var doubleTapEvent: DoubleTapEvent?
    private var textChangedEvent: TextChangedEvent?
    lazy var textView: UITextView = {
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

        return view
    }()

    func set(text: String,
             onDoubleTap: @escaping DoubleTapEvent,
             onPinch: @escaping PinchEvent,
             onTextChanged: @escaping TextChangedEvent) {
        doubleTapEvent = onDoubleTap
        pinchExpandUpdater = onPinch
        textChangedEvent = onTextChanged
        textView.text = text
        textView.delegate = self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        doubleTapEvent = nil
        pinchExpandUpdater = nil
        textChangedEvent = nil
        textView.delegate = nil
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("no implemented")
    }
}

extension InputCollectionCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.size.width,
                                                   height: CGFloat.greatestFiniteMagnitude))
        textChangedEvent?((text: textView.text, fitHeight: newSize.height))
    }
}

private extension InputCollectionCell {
    func setup() {
        backgroundColor = .themeLightGray
        contentView.addSubview(textView)
        textView.setConstrainsEqualToParentEdges(top: 1, bottom: 1, leading: 1, trailing: 1)
        addGestureRecognizers()
    }

    func addGestureRecognizers() {
        textView.gestureRecognizers = nil
        textView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        textView.addGestureRecognizer(tapRecognizer)

        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        doubleTapRecognizer.cancelsTouchesInView = true
        textView.addGestureRecognizer(doubleTapRecognizer)

        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        textView.addGestureRecognizer(pinchRecognizer)

        tapRecognizer.require(toFail: doubleTapRecognizer)
        tapRecognizer.require(toFail: pinchRecognizer)
    }

    @objc func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        pinchExpandUpdater?(recognizer)
        recognizer.scale = 1.0
    }

    @objc func didDoubleTap(_ sender: UITapGestureRecognizer) {
        doubleTapEvent?()
    }

    @objc func didTap(_ sender: UITapGestureRecognizer) {
        textView.becomeFirstResponder()
    }
}
#if DEBUG
@available(iOS 13.0.0, *)
struct InputCollectionCellPreview: PreviewProvider {
    static var previews: some View {
        return Group {
            UIKitViewPreview(view: InputCollectionCell(frame: UIScreen.main.bounds))
        }
    }
}
#endif

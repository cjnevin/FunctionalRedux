//
//  TextField.swift
//  Example
//
//  Created by Chris Nevin on 03/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import Render
import UIKit

class TextFieldComponent: Component<UITextField> {
    private var onReturn: (() -> Void)?
    private var onChange: ((String?) -> AppAction)?
    private var accessory: ButtonComponent? {
        didSet {
            unbox.rightView = accessory?.unbox
            unbox.rightViewMode = .always
        }
    }

    convenience init(configure: @escaping (TextFieldComponent) -> Void) {
        let textField = InsetTextField(frame: .zero)
        self.init(textField)
        configure(self)
        unbox.addTarget(self, action: #selector(onResignEvent), for: .editingDidEndOnExit)
        unbox.addTarget(self, action: #selector(onChangeEvent), for: .editingChanged)
    }

    func input(_ keyPath: KeyPath<AppState, String?>) {
        subscribe(keyPath) { [weak self] state in
            self?.unbox.text = state
        }
    }

    func setOnChange(_ action: @escaping (String?) -> AppAction) {
        onChange = action
        onChangeEvent()
    }

    func setOnReturn(_ action: @escaping () -> Void) {
        self.onReturn = action
    }

    func setAccessory(image: UIImage, action: @escaping () -> AppAction) {
        accessory = ButtonComponent {
            $0.apply(style: Styles.background(.white).cast() <> Styles.image(image))
            $0.unbox.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 10)
            $0.unbox.frame = CGRect(origin: .zero, size: image.size.plus(x: 5, y: 0))
            $0.setOnTap(action)
        }
    }

    @objc func onResignEvent() {
        onReturn?()
    }

    @objc func onChangeEvent() {
        onChange.map { store.dispatch($0(unbox.text)) }
    }
}

private class InsetTextField: UITextField {
    private func inset(forBounds bounds: CGRect) -> CGRect {
        if let right = rightView?.frame.width {
            return CGRect(x: bounds.origin.x + 10,
                          y: bounds.origin.y,
                          width: bounds.width - right - 10,
                          height: bounds.height)
        }
        return bounds.insetBy(dx: 10, dy: 0)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return inset(forBounds: bounds)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return inset(forBounds: bounds)
    }
}

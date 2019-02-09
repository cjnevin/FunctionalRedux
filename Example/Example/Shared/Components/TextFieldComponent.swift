//
//  TextField.swift
//  Example
//
//  Created by Chris Nevin on 03/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Render
import UIKit

final class TextFieldComponent: Component<UITextField> {
    private var onReturn: (() -> Void)?
    private var onChange: ((String?) -> AppAction)?

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

    @objc func onResignEvent() {
        onReturn?()
    }

    @objc func onChangeEvent() {
        onChange.map { store.dispatch($0(unbox.text)) }
    }
}

private class InsetTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
}

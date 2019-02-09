//
//  Button.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Render
import UIKit

final class ButtonComponent: Component<UIButton> {
    private var onTap: (() -> AppAction)?

    convenience init(configure: @escaping (ButtonComponent) -> Void) {
        let button = UIButton(frame: .zero)
        self.init(button)
        configure(self)
        unbox.addTarget(self, action: #selector(onTapEvent), for: .touchUpInside)
    }

    func isEnabled(_ keyPath: KeyPath<AppState, Bool>) {
        subscribe(keyPath) { [weak self] state in
            self?.unbox.isEnabled = state
        }
    }

    func setOnTap(_ action: @escaping () -> AppAction) {
        onTap = action
    }

    @objc func onTapEvent() {
        onTap.map { store.dispatch($0()) }
    }
}


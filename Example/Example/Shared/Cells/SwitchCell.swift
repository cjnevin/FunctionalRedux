//
//  SwitchCell.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Render
import UIKit

final class SwitchCell: TextCell {
    private lazy var toggle = UISwitch(frame: .zero)
    private var onSwitch: ((Bool) -> AppAction)?

    override func layoutSubviews() {
        super.layoutSubviews()
        accessoryView = toggle
        toggle.addTarget(self, action: #selector(onSwitchEvent), for: .valueChanged)
    }

    func setOn(_ on: Bool) {
        toggle.isOn = on
    }

    func setOnToggle(_ action: @escaping (Bool) -> AppAction) {
        onSwitch = action
    }

    @objc private func onSwitchEvent() {
        (onSwitch?(toggle.isOn)).map(store.dispatch)
    }
}

//
//  StackView.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import UIKit

extension Component where T: UIStackView {
    public func addSubview<U: UIView>(_ view: U, constraints: Constraint) {
        unbox.addArrangedSubview(view)
        apply(constraints, to: view)
    }

    public func addSubview<U: UIView>(_ box: Component<U>, constraints: Constraint) {
        addSubview(box.unbox, constraints: constraints)
    }

    public func resignFirstResponders() {
        unbox.arrangedSubviews.compactMap { $0 as? UITextField }.forEach { $0.resignFirstResponder() }
    }
}

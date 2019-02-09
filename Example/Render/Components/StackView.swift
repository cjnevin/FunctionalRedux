//
//  StackView.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import UIKit

extension Component where T: UIStackView {
    public func addSubview<U: UIView>(_ box: Component<U>, constraint: @escaping Constraint) {
        addSubview(box, constraints: [constraint])
    }

    public func addSubview<U: UIView>(_ box: Component<U>, constraints: [Constraint]) {
        unbox.addArrangedSubview(box.unbox)
        apply(constraints, to: box)
    }

    public func resignFirstResponders() {
        unbox.arrangedSubviews.compactMap { $0 as? UITextField }.forEach { $0.resignFirstResponder() }
    }
}

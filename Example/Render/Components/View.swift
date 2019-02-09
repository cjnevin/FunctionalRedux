//
//  View.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import UIKit

extension Component where T: UIView {
    public func addSubview<U: UIView>(_ box: Component<U>, constraint: @escaping Constraint) {
        addSubview(box, constraints: [constraint])
    }

    public func addSubview<U: UIView>(_ box: Component<U>, constraints: [Constraint]) {
        unbox.addSubview(box.unbox)
        apply(constraints, to: box)
    }

    public func apply<U: UIView>(_ constraints: [Constraint], to box: Component<U>) {
        box.unbox.translatesAutoresizingMaskIntoConstraints = false
        constraints.forEach { constrain in
            constrain(unbox, box.unbox).isActive = true
        }
    }
}

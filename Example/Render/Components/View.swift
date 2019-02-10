//
//  View.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import UIKit

extension Component where T: UIView {
    public func addSubview<U: UIView>(_ view: U, constraints: Constraint) {
        unbox.addSubview(view)
        apply(constraints, to: view)
    }

    public func addSubview<U: UIView>(_ box: Component<U>, constraints: Constraint) {
        addSubview(box.unbox, constraints: constraints)
    }

    public func apply<U: UIView>(_ constraints: Constraint, to view: U) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints.make(unbox, view))
    }

    public func apply<U: UIView>(_ constraints: Constraint, to box: Component<U>) {
        apply(constraints, to: box.unbox)
    }
}

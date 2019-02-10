//
//  VisualEffectView.swift
//  Render
//
//  Created by Chris Nevin on 10/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import UIKit

extension Component where T: UIVisualEffectView {
    public func addSubview<U: UIView>(_ view: U, constraints: Constraint) {
        unbox.contentView.addSubview(view)
        apply(constraints, to: view)
    }

    public func addSubview<U: UIView>(_ box: Component<U>, constraints: Constraint) {
        addSubview(box.unbox, constraints: constraints)
    }
}

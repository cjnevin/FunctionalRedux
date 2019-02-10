//
//  LoadingComponent.swift
//  Example
//
//  Created by Chris Nevin on 10/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation
import Render

final class LoadingComponent: Component<UIVisualEffectView> {
    var isLoading: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.5) {
                self.unbox.effect = self.isLoading ? UIBlurEffect(style: .light) : nil
            }
        }
    }

    convenience init() {
        self.init(UIVisualEffectView())
        unbox.isUserInteractionEnabled = false
    }
}

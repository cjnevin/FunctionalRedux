//
//  RootComponent.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Render
import UIKit

final class AppWindowComponent: WindowComponent {
    public convenience init() {
        self.init(UIWindow(frame: UIScreen.main.bounds))
        root = AppTabBarControllerComponent().downcast()
    }
}

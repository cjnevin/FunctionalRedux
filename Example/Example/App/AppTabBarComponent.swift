//
//  AppTabBarComponent.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation
import Render

final class AppTabBarControllerComponent: TabBarControllerComponent {
    convenience init() {
        let videos = VideosComponent.navigationComponent(style: .grouped).downcast()
        let account = AccountComponent.navigationComponent(style: .plain).downcast()
        self.init([videos, account])
        apply(style: Styles.view.default.promote())
        unbox.tabBar.items?.first?.title = "Videos"
        unbox.tabBar.items?.last?.title = "Account"
    }
}

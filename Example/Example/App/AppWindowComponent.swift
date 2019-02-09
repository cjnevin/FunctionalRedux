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
    func setup() {
        let videos = VideosComponent.navigationComponent(style: .grouped)
        let account = AccountComponent.navigationComponent(style: .plain)
        let tabBar = TabBarControllerComponent([videos.downcast(), account.downcast()])
        tabBar.unbox.tabBar.items?.first?.title = "Videos"
        tabBar.unbox.tabBar.items?.last?.title = "Account"
        apply(style: Styles.whiteViewStyle.promote())
        root = tabBar.downcast()
    }
}

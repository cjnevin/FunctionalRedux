//
//  AlertView.swift
//  Render
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import UIKit

public final class AlertComponent: Component<UIAlertController> {
    public convenience init(alert: Alert) {
        self.init(alert.controller)
    }
}

public struct Alert {
    public struct Button {
        public enum Style {
            case `default`
            case cancel
            case destructive
        }
        let title: String?
        let style: Style
        let callback: (() -> Void)?

        public init(_ title: String?, style: Style = .default, callback: (() -> Void)? = nil) {
            self.title = title
            self.style = style
            self.callback = callback
        }
    }
    public enum Style {
        case alert
        case actionSheet
    }

    let title: String?
    let message: String?
    let style: Style
    let buttons: [Button]

    public init(_ title: String? = nil, message: String? = nil, style: Style = .alert, buttons: [Button]) {
        self.title = title
        self.message = message
        self.style = style
        self.buttons = buttons
    }
}

extension UIAlertController {
    static func from(alert: Alert) -> UIAlertController {
        let controller = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: alert.style.style)
        alert.buttons.actions.forEach(controller.addAction)
        return controller
    }
}

extension UIAlertAction {
    static func from(button: Alert.Button) -> UIAlertAction {
        return UIAlertAction(
            title: button.title,
            style: button.style.style,
            handler: { _ in button.callback?() })
    }
}

extension Sequence where Element == Alert.Button {
    var actions: [UIAlertAction] {
        return map(UIAlertAction.from)
    }
}

extension Alert.Style {
    var style: UIAlertController.Style {
        switch self {
        case .alert: return .alert
        case .actionSheet: return .actionSheet
        }
    }
}

extension Alert.Button.Style {
    var style: UIAlertAction.Style {
        switch self {
        case .cancel: return .cancel
        case .default: return .default
        case .destructive: return .destructive
        }
    }
}

extension Alert {
    var controller: UIAlertController {
        return .from(alert: self)
    }
}

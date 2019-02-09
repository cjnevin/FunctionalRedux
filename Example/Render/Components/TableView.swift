//
//  TableViewCell.swift
//  Render
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation

public protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable where Self: UITableViewCell {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

open class TableViewCell: UITableViewCell, Reusable { }

extension UITableView {
    public func register<T: Reusable & UITableViewCell>(_ type: T.Type) {
        register(type.self, forCellReuseIdentifier: type.reuseIdentifier)
    }

    public func dequeue<T: Reusable & UITableViewCell>(_ type: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: type.reuseIdentifier) as? T
    }

    public func dequeue<T: Reusable & UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as! T
    }
}

extension Component where T: UITableView {
    public func register<T: Reusable & UITableViewCell>(_ type: T.Type) {
        unbox.register(type)
    }

    public func dequeue<T: Reusable & UITableViewCell>(_ type: T.Type) -> T? {
        return unbox.dequeue(type)
    }

    public func dequeue<T: Reusable & UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        return unbox.dequeue(type, for: indexPath)
    }
}

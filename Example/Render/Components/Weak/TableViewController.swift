//
//  TableViewController.swift
//  Render
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import UIKit

open class TableViewController: UITableViewController {
    private let componentType: WeakComponent<TableViewController>.Type
    private var component: WeakComponent<TableViewController>!

    public init(_ componentType: WeakComponent<TableViewController>.Type, style: UITableView.Style) {
        self.componentType = componentType
        super.init(style: style)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        component = componentType.init(self)
    }
}

extension WeakComponent where T == TableViewController {
    public static func tableViewController(style: UITableView.Style) -> TableViewController {
        return TableViewController(self, style: style)
    }

    public static func navigationController(style: UITableView.Style) -> UINavigationController {
        return UINavigationController(rootViewController: tableViewController(style: style))
    }

    public static func navigationComponent(style: UITableView.Style) -> NavigationControllerComponent {
        return NavigationControllerComponent(navigationController(style: style))
    }
}

extension WeakComponent where T: TableViewController {
    public func register<T: Reusable & UITableViewCell>(_ type: T.Type) {
        unbox?.tableView.register(type)
    }

    public func dequeue<T: Reusable & UITableViewCell>(_ type: T.Type) -> T? {
        return unbox?.tableView.dequeue(type)
    }

    public func dequeue<T: Reusable & UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T? {
        return unbox?.tableView.dequeue(type, for: indexPath)
    }
}

extension WeakComponent where T: TableViewController {
    public func setDataSource(_ dataSource: UITableViewDataSource) {
        unbox?.tableView.dataSource = dataSource
    }

    public func setDelegate(_ delegate: UITableViewDelegate) {
        unbox?.tableView.delegate = delegate
    }

    public func reloadData() {
        unbox?.tableView.reloadData()
    }
}

public struct TableViewSection<T> {
    public let title: String?
    public let items: [T]
    public init(title: String?, items: [T]) {
        self.title = title
        self.items = items
    }
}

open class TableViewControllerComponent<T>: WeakComponent<TableViewController>, UITableViewDataSource, UITableViewDelegate {
    public var sections: [TableViewSection<T>] = [] {
        didSet { reloadData() }
    }

    public required init(_ value: TableViewController) {
        super.init(value)
        setDataSource(self)
        setDelegate(self)
    }

    open func render(_ item: T, at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        fatalError("Must override")
    }

    open func tapped(_ item: T, at indexPath: IndexPath, in tableView: UITableView) {
        fatalError("Must override")
    }

    open func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return render(self[indexPath], at: indexPath, in: tableView)
    }

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tapped(self[indexPath], at: indexPath, in: tableView)
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self[section].title
    }

    public subscript(indexPath: IndexPath) -> T {
        return sections[indexPath.section].items[indexPath.row]
    }

    public subscript(section: Int) -> TableViewSection<T> {
        return sections[section]
    }
}

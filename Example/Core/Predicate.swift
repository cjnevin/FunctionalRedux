//
//  Predicate.swift
//  Core
//
//  Created by Chris Nevin on 11/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation

public typealias Predicate<A> = Function<A, Bool>

public func || <A> (lhs: Predicate<A>, rhs: Predicate<A>) -> Predicate<A> {
    return lhs + rhs
}

public func && <A> (lhs: Predicate<A>, rhs: Predicate<A>) -> Predicate<A> {
    return lhs * rhs
}

public prefix func ! <A> (p: Predicate<A>) -> Predicate<A> {
    return .init { !p.execute($0) }
}

extension Sequence {
    public func filtered(by predicate: Predicate<Element>) -> [Element] {
        return self.filter(predicate.execute)
    }
}

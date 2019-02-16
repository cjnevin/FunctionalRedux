//
//  Storage.swift
//  Core
//
//  Created by Chris Nevin on 10/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation

public struct Storage<T> {
    public let get: () -> T?
    public let set: (T?) -> Void

    public init(get: @escaping () -> T?, set: @escaping (T?) -> Void) {
        self.get = get
        self.set = set
    }
}

extension Storage: Semigroup {
    /// Assumption: Right hand side is ultimate source of truth (i.e. disk),
    /// left hand side is (faster) buffer.
    public func combine(with other: Storage) -> Storage {
        return Storage(get: {
            if let left = self.get() {
                other.set(left)
                return left
            } else if let right = other.get() {
                self.set(right)
                return right
            } else {
                return nil
            }
        }, set: { value in
            self.set(value)
            other.set(value)
        })
    }
}

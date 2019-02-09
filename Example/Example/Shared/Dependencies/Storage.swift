//
//  Storage.swift
//  Example
//
//  Created by Chris Nevin on 31/01/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation
import Core

struct GetterSetter<T> {
    let get: () -> T?
    let set: (T) -> Void
}

func createStorage<K, V>(initialValue: [K: V]) -> (K) -> GetterSetter<V> {
    var copy = initialValue
    return { key in
        let affine = [K: V].mutableAffine(at: key)
        return GetterSetter<V>(get: { () -> V? in
            affine.tryGet(copy)
        }, set: { (value) in
            affine.trySet(value, &copy)
        })
    }
}

//
//  Affine.swift
//  Core
//
//  Created by Chris Nevin on 03/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation

public struct Affine<Whole, Part> {
    public let tryGet: (Whole) -> Part?
    public let trySet: (Part) -> (Whole) -> Whole?
    
    public init(tryGet: @escaping (Whole) -> Part?,
                trySet: @escaping (Part) -> (Whole) -> Whole?) {
        self.tryGet = tryGet
        self.trySet = trySet
    }
}

public struct MutableAffine<Whole, Part> {
    public let tryGet: (Whole) -> Part?
    public let trySet: (Part, inout Whole) -> Void
    
    public init(tryGet: @escaping (Whole) -> Part?,
                trySet: @escaping (Part, inout Whole) -> Void) {
        self.tryGet = tryGet
        self.trySet = trySet
    }
}

extension Dictionary {
    public static func affine(at key: Key) -> Affine<Dictionary, Value> {
        return Affine<Dictionary, Value>(tryGet: { dictionary -> Value? in
            return dictionary[key]
        }, trySet: { value in
            { dictionary in
                var copy = dictionary
                copy[key] = value
                return copy
            }
        })
    }
}

extension Dictionary {
    public static func mutableAffine(at key: Key) -> MutableAffine<Dictionary, Value> {
        return MutableAffine<Dictionary, Value>(tryGet: { dictionary -> Value? in
            return dictionary[key]
        }, trySet: { value, dictionary in
            dictionary[key] = value
        })
    }
}

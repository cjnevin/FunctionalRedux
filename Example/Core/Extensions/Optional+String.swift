//
//  Optional+String.swift
//  Core
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    public var isEmpty: Bool {
        return map { $0.isEmpty } ?? true
    }

    public var isNotEmpty: Bool {
        return !isEmpty
    }
}

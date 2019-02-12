//
//  Decodable+Data.swift
//  Core
//
//  Created by Chris Nevin on 12/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation

extension Decodable {
    public static func from(data: Data) -> Self? {
        return try? JSONDecoder().decode(self, from: data)
    }
}

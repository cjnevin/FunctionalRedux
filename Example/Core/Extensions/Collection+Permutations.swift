//
//  Collection+Permutations.swift
//  Core
//
//  Created by Chris Nevin on 11/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation

extension Collection {
    func permutations() -> [[Iterator.Element]] {
        var scratch = Array(self)
        var result: [[Iterator.Element]] = []
        func heap(_ n: Int) {
            if n == 1 {
                result.append(scratch)
                return
            }
            let c = n - 1
            (0..<c).forEach { i in
                heap(c)
                let j = (n % 2 == 1) ? 0 : i
                scratch.swapAt(j, c)
            }
            heap(c)
        }
        heap(scratch.count)
        return result
    }
}

//
//  TextCell.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Render
import UIKit

class TextCell: TableViewCell {
    func setText(_ text: String) {
        Styles.table.cell.normal(text).apply(to: self)
    }
}

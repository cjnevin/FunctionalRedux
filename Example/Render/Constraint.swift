//
//  Constraint.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import UIKit

public typealias Constraint = (_ parent: UIView, _ child: UIView) -> NSLayoutConstraint

public func height(equalTo: CGFloat = 0) -> Constraint {
    return { _, child in
        child.heightAnchor.constraint(equalToConstant: equalTo)
    }
}

public func height(lessThan: CGFloat = 0) -> Constraint {
    return { _, child in
        child.heightAnchor.constraint(lessThanOrEqualToConstant: lessThan)
    }
}

public func relativeHeight(multiplier: CGFloat = 0) -> Constraint {
    return { parent, child in
        child.heightAnchor.constraint(equalTo: parent.heightAnchor, multiplier: multiplier)
    }
}

public func equalTop(offset: CGFloat = 0) -> Constraint {
    return { parent, child in
        child.topAnchor.constraint(equalTo: parent.topAnchor, constant: offset)
    }
}

public func equalTopSafeArea(offset: CGFloat = 0) -> Constraint {
    return { parent, child in
        child.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: offset)
    }
}

public func equalLeading(offset: CGFloat = 0) -> Constraint {
    return { parent, child in
        child.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: offset)
    }
}
public func equalTrailing(offset: CGFloat = 0) -> Constraint {
    return { parent, child in
        child.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: offset)
    }
}

public func equalCenterX(offset: CGFloat = 0) -> Constraint {
    return { parent, child in
        child.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: offset)
    }
}

public func equalCenterY(offset: CGFloat = 0) -> Constraint {
    return { parent, child in
        child.centerYAnchor.constraint(equalTo: parent.centerYAnchor, constant: offset)
    }
}

public func equalRight(offset: CGFloat = 0) -> Constraint {
    return { parent, child in
        child.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: offset)
    }
}

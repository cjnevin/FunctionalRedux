//
//  Constraint.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import UIKit

public struct Constraint {
    public typealias Make = (_ parent: UIView, _ child: UIView) -> [NSLayoutConstraint]
    let make: Make
    public init(_ make: @escaping Make) {
        self.make = make
    }
}

extension Constraint: Semigroup {
    public func combine(with other: Constraint) -> Constraint {
        return Constraint { parent, child in
            return self.make(parent, child)
                <> other.make(parent, child)
        }
    }
}

extension Constraint {
    public static func height(equalTo: CGFloat = 0) -> Constraint {
        return .init { _, child in
            [child.heightAnchor.constraint(equalToConstant: equalTo)]
        }
    }

    public static func height(lessThan: CGFloat = 0) -> Constraint {
        return .init { _, child in
            [child.heightAnchor.constraint(lessThanOrEqualToConstant: lessThan)]
        }
    }

    public static func relativeHeight(multiplier: CGFloat = 0) -> Constraint {
        return .init { parent, child in
            [child.heightAnchor.constraint(equalTo: parent.heightAnchor, multiplier: multiplier)]
        }
    }

    public static func equalEdges(offset: CGFloat = 0) -> Constraint {
        return equalHorizontalEdges(offset: offset)
            <> equalVerticalEdges(offset: offset)
    }

    public static func equalHorizontalEdges(offset: CGFloat = 0) -> Constraint {
        return equalLeading(offset: offset)
            <> equalTrailing(offset: -offset)
    }

    public static func equalVerticalEdges(offset: CGFloat = 0) -> Constraint {
        return equalTop(offset: offset)
            <> equalBottom(offset: -offset)
    }

    public static func equalTop(offset: CGFloat = 0) -> Constraint {
        return .init { parent, child in
            [child.topAnchor.constraint(equalTo: parent.topAnchor, constant: offset)]
        }
    }

    public static func equalBottom(offset: CGFloat = 0) -> Constraint {
        return .init { parent, child in
            [child.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: offset)]
        }
    }

    public static func equalTopSafeArea(offset: CGFloat = 0) -> Constraint {
        return .init { parent, child in
            [child.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: offset)]
        }
    }

    public static func equalBottomSafeArea(offset: CGFloat = 0) -> Constraint {
        return .init { parent, child in
            [child.bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor, constant: offset)]
        }
    }

    public static func equalLeading(offset: CGFloat = 0) -> Constraint {
        return .init { parent, child in
            [child.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: offset)]
        }
    }
    public static func equalTrailing(offset: CGFloat = 0) -> Constraint {
        return .init { parent, child in
            [child.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: offset)]
        }
    }

    public static func equalCenterX(offset: CGFloat = 0) -> Constraint {
        return .init { parent, child in
            [child.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: offset)]
        }
    }

    public static func equalCenterY(offset: CGFloat = 0) -> Constraint {
        return .init { parent, child in
            [child.centerYAnchor.constraint(equalTo: parent.centerYAnchor, constant: offset)]
        }
    }

    public static func equalCenter(offset: CGFloat = 0) -> Constraint {
        return equalCenterX(offset: offset)
            <> equalCenterY(offset: offset)
    }

    public static func equalRight(offset: CGFloat = 0) -> Constraint {
        return .init { parent, child in
            [child.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: offset)]
        }
    }
}

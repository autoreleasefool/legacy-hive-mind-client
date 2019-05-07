//
//  Movement+Extensions.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-03-01.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import HiveEngine

extension Movement: Comparable {
	public static func < (lhs: Movement, rhs: Movement) -> Bool {
		guard let lhsMovedUnit = lhs.movedUnit, let rhsMovedUnit = rhs.movedUnit else {
			return lhs.movedUnit != nil
		}

		if lhsMovedUnit == rhsMovedUnit {
			guard let lhsTargetPosition = lhs.targetPosition, let rhsTargetPosition = rhs.targetPosition else {
				return lhs.targetPosition != nil
			}

			return lhsTargetPosition < rhsTargetPosition
		} else {
			return lhsMovedUnit < rhsMovedUnit
		}
	}
}

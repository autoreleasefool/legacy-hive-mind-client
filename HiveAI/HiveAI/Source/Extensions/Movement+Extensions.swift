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
		if lhs.movedUnit == rhs.movedUnit {
			return lhs.targetPosition < rhs.targetPosition
		} else {
			return lhs.movedUnit < rhs.movedUnit
		}
	}
}

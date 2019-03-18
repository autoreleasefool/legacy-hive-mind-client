//
//  Position+Extensions.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-03-18.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import HiveEngine

extension Position: Comparable {
	public static func < (lhs: Position, rhs: Position) -> Bool {
		if lhs.x == rhs.x {
			if lhs.y == rhs.y {
				return lhs.z < rhs.z
			} else {
				return lhs.y < rhs.y
			}
		} else {
			return lhs.x < rhs.x
		}
	}
}

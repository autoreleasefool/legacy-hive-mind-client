//
//  Movement+Extensions.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-03-01.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import HiveEngine

extension Movement {
	static func naturalSort(m1: Movement, m2: Movement) -> Bool {
		if m1.movedUnit == m2.movedUnit {
			switch (m1.targetPosition, m2.targetPosition) {
			case (.inPlay(let x1, let y1, let z1), .inPlay(let x2, let y2, let z2)): return (x1, y1, z1) < (x2, y2, z2)
			case (.inHand, _): return false
			case (_, .inHand): return true
			}
		} else {
			return m1.movedUnit.description < m2.movedUnit.description
		}
	}
}

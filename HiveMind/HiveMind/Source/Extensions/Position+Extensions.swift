//
//  Position+Extensions.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-03-01.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import HiveEngine

extension Position {
	static func naturalSort(p1: Position, p2: Position) -> Bool {
		switch (p1, p2) {
		case (.inPlay(let x1, let y1, let z1), .inPlay(let x2, let y2, let z2)):
			return (x1, y1, z1) < (x2, y2, z2)
		case (.inHand, _): return false
		case (_, .inHand): return true
		}
	}
}

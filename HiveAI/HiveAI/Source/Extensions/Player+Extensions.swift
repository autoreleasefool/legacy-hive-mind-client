//
//  Player+Extensions.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-03-18.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import HiveEngine

extension Player: Comparable {
	public static func < (lhs: Player, rhs: Player) -> Bool {
		switch (lhs, rhs) {
		case (.white, .black): return true
		case (_, _): return false
		}
	}
}

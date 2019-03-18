//
//  GameState+Extensions.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-02-28.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import HiveEngine

extension GameState {
	func position(of unit: HiveEngine.Unit) -> Position? {
		return unitsInPlay[unit.owner]![unit]
	}
}

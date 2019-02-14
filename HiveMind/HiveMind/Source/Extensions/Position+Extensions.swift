//
//  Position+Extensions.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

extension Position {
	func toString() -> String {
		switch self {
		case .inHand:
			return "In Hand"
		case .inPlay(let x, let y, let z):
			return "(\(x), \(y), \(z))"
		}
	}
}

//
//  Movement+Extensions.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-03-01.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import HiveEngine

/// Map `HiveEngine.Movement`s to a simpler categorization
enum MovementCategory: String {
	case move = "Move"
	case place = "Place"
	case yoink = "Yoink"
	case pass = "Pass"

	/// A graphic representation of the category
	var image: UIImage {
		switch self {
		case .move: return Asset.Movement.move.image
		case .place: return Asset.Movement.place.image
		case .yoink: return Asset.Movement.yoink.image
		case .pass: return Asset.Movement.pass.image
		}
	}

	/// Map a `Movement` to its respective `MovementCategory`
	static func from(_ movement: Movement) -> MovementCategory {
		switch movement {
		case .move: return .move
		case .place: return .place
		case .yoink: return .yoink
		case .pass: return .pass
		}
	}
}

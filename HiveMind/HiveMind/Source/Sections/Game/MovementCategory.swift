//
//  Movement+Extensions.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-03-01.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import HiveEngine

enum MovementCategory: String {
	case move = "Move"
	case place = "Place"
	case yoink = "Yoink"

	var image: UIImage {
		switch self {
		case .move: return Asset.Movement.move.image
		case .place: return Asset.Movement.place.image
		case .yoink: return Asset.Movement.yoink.image
		}
	}

	static func from(_ movement: Movement) -> MovementCategory {
		switch movement {
		case .move: return .move
		case .place: return .place
		case .yoink: return .yoink
		}
	}
}

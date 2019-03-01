//
//  Unit+Extensions.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import HiveEngine

extension HiveEngine.Unit {
	var image: UIImage {
		switch owner {
		case .white:
			switch `class` {
			case .ant: return Asset.Unit.White.ant.image
			case .beetle: return Asset.Unit.White.beetle.image
			case .hopper: return Asset.Unit.White.hopper.image
			case .ladyBug: return Asset.Unit.White.ladyBug.image
			case .mosquito: return Asset.Unit.White.mosquito.image
			case .pillBug: return Asset.Unit.White.pillBug.image
			case .queen: return Asset.Unit.White.queen.image
			case .spider: return Asset.Unit.White.spider.image
			}
		case .black:
			switch `class` {
			case .ant: return Asset.Unit.Black.ant.image
			case .beetle: return Asset.Unit.Black.beetle.image
			case .hopper: return Asset.Unit.Black.hopper.image
			case .ladyBug: return Asset.Unit.Black.ladyBug.image
			case .mosquito: return Asset.Unit.Black.mosquito.image
			case .pillBug: return Asset.Unit.Black.pillBug.image
			case .queen: return Asset.Unit.Black.queen.image
			case .spider: return Asset.Unit.Black.spider.image
			}
		}
	}
}

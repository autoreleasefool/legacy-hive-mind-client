//
//  Unit+Extensions.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

extension Unit {
	var image: UIImage {
		return UIImage(named: "\(owner.rawValue.capitalizeFirst()) \(`class`.rawValue.capitalizeFirst())")!
	}
}

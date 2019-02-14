//
//  String+Extensions.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

extension String {
	func capitalizeFirst() -> String {
		return self.prefix(1).uppercased() + self.suffix(from: self.index(after: self.startIndex))
	}
}

//
//  Colors.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

extension UIColor {
	convenience init(hexString: String, alpha: CGFloat = 1.0) {
		var hexInt: UInt32 = 0
		let scanner = Scanner(string: hexString)
		scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
		scanner.scanHexInt32(&hexInt)

		let red = CGFloat((hexInt & 0xff0000) >> 16) / 255.0
		let green = CGFloat((hexInt & 0xff00) >> 8) / 255.0
		let blue = CGFloat((hexInt & 0xff) >> 0) / 255.0

		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}
}

struct Colors {

	struct Text {
		static let body: UIColor = .black
		static let caption = UIColor(hexString: "#333333")
	}

	static let background = UIColor(hexString: "#FFFFFF")
	static let listItem = UIColor(hexString: "#F5F5F5")
	static let divider = UIColor(hexString: "#000000", alpha: 0.2)
}

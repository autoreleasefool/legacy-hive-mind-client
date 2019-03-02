//
//  Colors.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-02-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

public struct Colors {

	struct Text {
		static let body: UIColor = .white
		static let caption = UIColor(hexString: "#FFFFFF", alpha: 0.7)
		static let action = Colors.primary

		struct NavigationBar {
			static let title: UIColor = .white
			static let components: UIColor = UIColor(hexString: "#FFFFFF", alpha: 0.7)
		}
	}

	static let primary = UIColor(hexString: "#EE5253")
	static let primaryBackground = UIColor(hexString: "#222F3E")
	static let secondary = UIColor(hexString: "#576574")
	static let separator = Colors.secondary
}

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

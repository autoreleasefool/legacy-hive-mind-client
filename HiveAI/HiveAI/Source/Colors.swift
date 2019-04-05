//
//  Colors.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-02-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

// swiftlint:disable nesting
// Disable nesting for namespacing of constants

import UIKit

public struct Colors {
	/// Text colors
	struct Text {
		/// Color for body text
		static let body: UIColor = .white
		/// Color for caption text
		static let caption = UIColor(hexString: "#FFFFFF", alpha: 0.7)
		/// Color for action text
		static let action = Colors.primary

		/// Navigation bar text colors
		struct NavigationBar {
			/// Color for the title in the navigation bar
			static let title: UIColor = .white
			/// Color for other components in the navigation bar
			static let components: UIColor = UIColor(hexString: "#FFFFFF", alpha: 0.7)
		}
	}

	/// Primary color
	static let primary = UIColor(hexString: "#EE5253")
	/// Primary background color
	static let primaryBackground = UIColor(hexString: "#222F3E")
	/// Secondary color, to complement the primary color
	static let secondary = UIColor(hexString: "#576574")
	/// Color for component separators
	static let separator = Colors.secondary
}

extension UIColor {
	/// Create a UIColor from a String of hexadecimal values
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

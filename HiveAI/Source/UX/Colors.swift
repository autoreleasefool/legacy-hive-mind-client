//
//  Colors.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-06-14.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import SwiftUI

extension Color {
	static let title = Color.white
	static let body = Color.white
	static let bodySecondary = Color.white.opacity(0.7)
	static let action = Color.foreground

	static let background = Color(r: 34, g: 47, b: 62)
	static let foreground = Color(r: 238, g: 82, b: 83)
	static let foregroundSecondary = Color(r: 87, g: 101, b: 116)
	static let separator = Color.foregroundSecondary
}

extension Color {
	init(r: Int, g: Int, b: Int) {
		self.init(red: Double(r) / 255.0, green: Double(g) / 255.0, blue: Double(b) / 255.0)
	}
}

//
//  Sizes.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-02-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import CoreGraphics

struct Sizes {
	/// Common sizes for spacing between or of components
	struct Spacing {
		static let large: CGFloat = 32.0
		static let base: CGFloat = 16.0
		static let small: CGFloat = 8.0
		static let smaller: CGFloat = 4.0
	}

	/// Common sizes for text
	struct Text {
		static let display: CGFloat = 44.0
		static let header: CGFloat = 24.0
		static let title: CGFloat = 20.0
		static let subtitle: CGFloat = 18.0
		static let body: CGFloat = 14.0
		static let caption: CGFloat = 12.0
	}

	/// Common sizes for images
	struct Images {
		static let listIcon: CGFloat = 44.0
	}
}

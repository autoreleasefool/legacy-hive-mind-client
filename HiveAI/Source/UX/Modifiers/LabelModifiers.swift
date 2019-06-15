//
//  LabelModifiers.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-06-14.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import SwiftUI

struct TitleText: ViewModifier {
	func body(content: Content) -> some View  {
		content
			.foregroundColor(.body)
			.font(.system(size: .titleText))
			.lineLimit(nil)
	}
}

struct BodyText: ViewModifier {
	func body(content: Content) -> some View  {
		content
			.foregroundColor(.body)
			.font(.system(size: .bodyText))
			.lineLimit(nil)
	}
}

struct CaptionText: ViewModifier {
	func body(content: Content) -> some View  {
		content
			.foregroundColor(.bodySecondary)
			.font(.system(size: .captionText))
			.lineLimit(nil)
	}
}

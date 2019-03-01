//
//  LabelCell.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-28.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

typealias LabelCell = HostCell<UILabel, LabelState, LayoutMarginsTableItemLayout>

struct LabelState: Equatable {
	private let text: String
	private let fontSize: CGFloat
	private let textColor: UIColor
	private let numberOfLines: Int
	private let alignment: NSTextAlignment

	init(text: String, fontSize: CGFloat = Sizes.Text.body, textColor: UIColor = Colors.Text.body, numberOfLines: Int = 1, alignment: NSTextAlignment = .left) {
		self.text = text
		self.fontSize = fontSize
		self.textColor = textColor
		self.numberOfLines = numberOfLines
		self.alignment = alignment
	}

	public static func updateView(_ view: UILabel, state: LabelState?) {
		guard let state = state else {
			view.text = nil
			return
		}

		view.text = state.text
		view.font = view.font.withSize(state.fontSize)
		view.textColor = state.textColor
		view.numberOfLines = state.numberOfLines
		view.textAlignment = state.alignment
	}
}

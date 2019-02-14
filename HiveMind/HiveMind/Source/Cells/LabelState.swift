//
//  LabelState.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import FunctionalTableData

typealias LabelCell = HostCell<UILabel, LabelState, LayoutMarginsTableItemLayout>

struct LabelState: Equatable {

	private let title: String
	private let fontSize: CGFloat

	init(title: String, fontSize: CGFloat) {
		self.title = title
		self.fontSize = fontSize
	}

	public static func updateView(_ view: UILabel, state: LabelState?) {
		guard let state = state else {
			view.text = nil
			return
		}

		view.text = state.title
		view.font = UIFont(name: view.font.fontName, size: state.fontSize)
	}
}

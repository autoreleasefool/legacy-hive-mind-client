//
//  ValueCell.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import FunctionalTableData

typealias ValueCell = HostCell<ValueCellView, ValueCellState, LayoutMarginsTableItemLayout>

class ValueCellView: UIView {

	fileprivate let title = UILabel()
	fileprivate let subtitle = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupViews() {
		let stackView = UIStackView(arrangedSubviews: [title, subtitle])
		stackView.alignment = .center
		stackView.axis = .horizontal

		stackView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(stackView)

		title.textColor = Colors.Text.body
		subtitle.textColor = Colors.Text.caption
		subtitle.textAlignment = .right

		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: topAnchor),
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: trailingAnchor),

			title.topAnchor.constraint(equalTo: stackView.topAnchor),
			title.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),

			subtitle.topAnchor.constraint(equalTo: stackView.topAnchor),
			subtitle.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
			])
	}

	fileprivate func prepareForReuse() {
		title.text = ""
		subtitle.text = ""
	}
}

struct ValueCellState: Equatable {

	private let title: String
	private let subtitle: String

	init(title: String, subtitle: String) {
		self.title = title
		self.subtitle = subtitle
	}

	public static func updateView(_ view: ValueCellView, state: ValueCellState?) {
		guard let state = state else {
			view.prepareForReuse()
			return
		}

		view.title.text = state.title
		view.subtitle.text = state.subtitle
	}
}

//
//  SwitchCell.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import FunctionalTableData

typealias SwitchCell = HostCell<SwitchCellView, SwitchCellState, LayoutMarginsTableItemLayout>

class SwitchCellView: UIView {

	fileprivate let toggle = UISwitch()
	fileprivate let title = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupViews() {
		let stackView = UIStackView(arrangedSubviews: [title, toggle])
		stackView.alignment = .center
		stackView.axis = .horizontal

		stackView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(stackView)

		title.textColor = Colors.Text.body
		toggle.isUserInteractionEnabled = false

		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: topAnchor),
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: trailingAnchor),

			title.topAnchor.constraint(equalTo: stackView.topAnchor),
			title.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
			])
	}

	fileprivate func prepareForReuse() {
		title.text = ""
	}
}

struct SwitchCellState: Equatable {

	private let title: String
	private let isOn: Bool

	init(title: String, isOn: Bool) {
		self.title = title
		self.isOn = isOn
	}

	public static func viewUpdater(_ view: SwitchCellView, state: SwitchCellState?) {
		guard let state = state else {
			view.prepareForReuse()
			return
		}

		view.title.text = state.title
		view.toggle.isOn = state.isOn
	}
}

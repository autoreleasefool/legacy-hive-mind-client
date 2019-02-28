//
//  HiveApiCell.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-27.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

typealias HiveApiCell = HostCell<HiveApiCellView, HiveApiCellState, LayoutMarginsTableItemLayout>

class HiveApiCellView: UIView {

	fileprivate let title = UILabel()
	fileprivate let desc = UILabel()
	fileprivate let icon = UIImageView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupViews() {
		title.translatesAutoresizingMaskIntoConstraints = false
		title.textColor = Colors.Text.body
		title .font = title.font.withSize(Sizes.Text.subtitle)
		addSubview(title)

		desc.translatesAutoresizingMaskIntoConstraints = false
		desc.textColor = Colors.Text.body
		desc.numberOfLines = 0
		desc.font = desc.font.withSize(Sizes.Text.body)
		addSubview(desc)

		icon.translatesAutoresizingMaskIntoConstraints = false
		icon.contentMode = .scaleAspectFill
		addSubview(icon)

		NSLayoutConstraint.activate([
			title.topAnchor.constraint(equalTo: topAnchor),
			title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: Sizes.Margins.small),
			title.trailingAnchor.constraint(equalTo: trailingAnchor),

			desc.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Sizes.Margins.smaller),
			desc.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: Sizes.Margins.small),
			desc.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
			desc.trailingAnchor.constraint(equalTo: trailingAnchor),

			icon.topAnchor.constraint(equalTo: topAnchor),
			icon.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
			icon.leadingAnchor.constraint(equalTo: leadingAnchor),
			icon.widthAnchor.constraint(equalToConstant: Sizes.Images.listIcon),
			icon.heightAnchor.constraint(equalToConstant: Sizes.Images.listIcon)
			])
	}

	fileprivate func prepareForReuse() {
		title.text = nil
		desc.text = nil
		icon.image = nil
		icon.isHidden = true
	}
}

struct HiveApiCellState: Equatable {

	private let title: String
	private let description: String
	private let icon: UIImage?

	init(title: String, description: String, icon: UIImage?) {
		self.title = title
		self.description = description
		self.icon = icon
	}

	public static func updateView(_ view: HiveApiCellView, state: HiveApiCellState?) {
		guard let state = state else {
			view.prepareForReuse()
			return
		}

		view.title.text = state.title
		view.desc.text = state.description

		if let icon = state.icon {
			view.icon.image = icon
			view.icon.isHidden = false
		} else {
			view.icon.isHidden = true
		}
	}
}

//
//  HiveApiCell.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-27.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

typealias ImageDetailCell = HostCell<ImageDetailCellView, ImageDetailCellState, LayoutMarginsTableItemLayout>

class ImageDetailCellView: UIView {

	fileprivate let title = UILabel()
	fileprivate let desc = UILabel()
	fileprivate let image = UIImageView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private static let imageHeightConstraintIdentifier = "ImageHeightConstraint"
	fileprivate var imageHeight: CGFloat? {
		didSet {
			image.constraints.first { $0.identifier == ImageDetailCellView.imageHeightConstraintIdentifier }?.isActive = false
			if let imageHeight = self.imageHeight {
				let newConstraint = image.heightAnchor.constraint(equalToConstant: imageHeight)
				newConstraint.identifier = ImageDetailCellView.imageHeightConstraintIdentifier
				newConstraint.isActive = true
			}
		}
	}

	private static let imageWidthConstraintIdentifier = "ImageWidthConstraint"
	fileprivate var imageWidth: CGFloat? {
		didSet {
			image.constraints.first { $0.identifier == ImageDetailCellView.imageWidthConstraintIdentifier }?.isActive = false
			if let imageWidth = self.imageWidth {
				let newConstraint = image.widthAnchor.constraint(equalToConstant: imageWidth)
				newConstraint.identifier = ImageDetailCellView.imageWidthConstraintIdentifier
				newConstraint.isActive = true
			}
		}
	}

	private func setupViews() {
		title.translatesAutoresizingMaskIntoConstraints = false
		title.textColor = Colors.Text.body
		title.font = title.font.withSize(Sizes.Text.subtitle)
		addSubview(title)

		desc.translatesAutoresizingMaskIntoConstraints = false
		desc.textColor = Colors.Text.body
		desc.numberOfLines = 0
		desc.font = desc.font.withSize(Sizes.Text.body)
		addSubview(desc)

		image.translatesAutoresizingMaskIntoConstraints = false
		image.contentMode = .scaleAspectFill
		addSubview(image)

		NSLayoutConstraint.activate([
			title.topAnchor.constraint(equalTo: topAnchor),
			title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: Sizes.Margins.small),
			title.trailingAnchor.constraint(equalTo: trailingAnchor),

			desc.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Sizes.Margins.smaller),
			desc.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: Sizes.Margins.small),
			desc.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
			desc.trailingAnchor.constraint(equalTo: trailingAnchor),

			image.topAnchor.constraint(equalTo: topAnchor),
			image.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
			image.leadingAnchor.constraint(equalTo: leadingAnchor),
			image.widthAnchor.constraint(equalToConstant: Sizes.Images.listIcon),
			image.heightAnchor.constraint(equalToConstant: Sizes.Images.listIcon)
			])
	}

	fileprivate func prepareForReuse() {
		title.text = nil
		desc.text = nil
		image.image = nil
		image.isHidden = true
		imageWidth = nil
		imageHeight = nil
	}
}

struct ImageDetailCellState: Equatable {

	private let title: String
	private let description: String
	private let icon: UIImage?
	private let imageWidth: CGFloat?
	private let imageHeight: CGFloat?

	init(title: String, description: String, icon: UIImage?, imageWidth: CGFloat? = nil, imageHeight: CGFloat? = nil) {
		self.title = title
		self.description = description
		self.icon = icon
		self.imageWidth = imageWidth
		self.imageHeight = imageHeight
	}

	public static func updateView(_ view: ImageDetailCellView, state: ImageDetailCellState?) {
		guard let state = state else {
			view.prepareForReuse()
			return
		}

		view.title.text = state.title
		view.desc.text = state.description

		if let icon = state.icon {
			view.image.image = icon
			view.imageWidth = state.imageWidth
			view.imageHeight = state.imageHeight
			view.image.isHidden = false
		} else {
			view.image.isHidden = true
		}
	}
}

//
//  ImageLabelCell.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-02-27.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

typealias ImageLabelCell = HostCell<ImageLabelCellView, ImageLabelCellState, LayoutMarginsTableItemLayout>

class ImageLabelCellView: UIView {

	fileprivate let image = UIImageView()
	fileprivate let label = UILabel()

	private static let imageHeightConstraintIdentifier = "ImageHeightConstraint"
	fileprivate var imageHeight: CGFloat? {
		didSet {
			image.constraints.first { $0.identifier == ImageLabelCellView.imageHeightConstraintIdentifier }?.isActive = false
			if let imageHeight = self.imageHeight {
				let newConstraint = image.heightAnchor.constraint(equalToConstant: imageHeight)
				newConstraint.identifier = ImageLabelCellView.imageHeightConstraintIdentifier
				newConstraint.isActive = true
			}
		}
	}

	private static let imageWidthConstraintIdentifier = "ImageWidthConstraint"
	fileprivate var imageWidth: CGFloat? {
		didSet {
			image.constraints.first { $0.identifier == ImageLabelCellView.imageWidthConstraintIdentifier }?.isActive = false
			if let imageWidth = self.imageWidth {
				let newConstraint = image.widthAnchor.constraint(equalToConstant: imageWidth)
				newConstraint.identifier = ImageLabelCellView.imageWidthConstraintIdentifier
				newConstraint.isActive = true
			}
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupViews() {
		image.translatesAutoresizingMaskIntoConstraints = false
		addSubview(image)

		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		addSubview(label)

		NSLayoutConstraint.activate([
			image.leadingAnchor.constraint(equalTo: leadingAnchor),
			image.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
			image.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),

			label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: Sizes.Margins.base),
			label.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
			label.centerYAnchor.constraint(equalTo: image.centerYAnchor),
			label.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
			label.trailingAnchor.constraint(equalTo: trailingAnchor)
			])
	}

	fileprivate func prepareForReuse() {
		image.image = nil
		label.text = nil
		imageWidth = nil
		imageHeight = nil
	}
}

struct ImageLabelCellState: Equatable {
	private let text: String
	private let image: UIImage
	private let fontSize: CGFloat
	private let textColor: UIColor
	private let imageWidth: CGFloat?
	private let imageHeight: CGFloat?
	private let imageContentMode: UIImageView.ContentMode

	init(text: String, image: UIImage, fontSize: CGFloat = Sizes.Text.body, textColor: UIColor = Colors.Text.body, imageWidth: CGFloat? = nil, imageHeight: CGFloat? = nil, imageContentMode: UIImageView.ContentMode = .scaleAspectFit) {
		self.text = text
		self.image = image
		self.fontSize = fontSize
		self.textColor = textColor
		self.imageWidth = imageWidth
		self.imageHeight = imageHeight
		self.imageContentMode = imageContentMode
	}

	public static func updateView(_ view: ImageLabelCellView, state: ImageLabelCellState?) {
		guard let state = state else {
			view.prepareForReuse()
			return
		}

		view.label.text = state.text
		view.label.font = view.label.font.withSize(state.fontSize)
		view.label.textColor = state.textColor
		view.image.image = state.image
		view.imageWidth = state.imageWidth
		view.imageHeight = state.imageHeight
		view.image.contentMode = state.imageContentMode
	}
}

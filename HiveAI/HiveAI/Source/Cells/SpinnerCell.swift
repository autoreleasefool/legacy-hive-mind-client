//
//  SpinnerCell.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-03-01.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

typealias SpinnerCell = HostCell<SpinnerCellView, SpinnerState, LayoutMarginsTableItemLayout>

class SpinnerCellView: UIView {

	fileprivate let spinner = UIActivityIndicatorView(style: .white)

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupViews() {
		spinner.translatesAutoresizingMaskIntoConstraints = false
		addSubview(spinner)

		NSLayoutConstraint.activate([
			spinner.leadingAnchor.constraint(equalTo: leadingAnchor),
			spinner.topAnchor.constraint(equalTo: topAnchor, constant: Sizes.Spacing.large),
			spinner.trailingAnchor.constraint(equalTo: trailingAnchor),
			spinner.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Sizes.Spacing.large)
			])
	}

	fileprivate func prepareForReuse() {
		spinner.isHidden = true
		spinner.stopAnimating()
	}
}

struct SpinnerState: Equatable {
	let isLoading: Bool

	public static func updateView(_ view: SpinnerCellView, state: SpinnerState?) {
		guard let state = state else {
			view.prepareForReuse()
			return
		}

		if state.isLoading {
			view.spinner.isHidden = false

			// Must dispatch to avoid interfering with FunctionalTableData animation
			DispatchQueue.main.async {
				view.spinner.startAnimating()
			}
		} else {
			view.spinner.isHidden = true
			view.spinner.stopAnimating()
		}
	}
}

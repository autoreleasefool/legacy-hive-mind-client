//
//  GameSettingsViewController.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-27.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

class GameSettingsViewController: UIViewController {

	private let api: HiveApi

	init(api: HiveApi) {
		self.api = api
		super.init(nibName: nil, bundle: nil)

		self.title = api.name
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = Colors.primaryBackground

		let willYouGoLabel: UILabel = {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.font = label.font.withSize(Sizes.Text.huge)
			label.textColor = Colors.Text.body
			label.text = "Will you go"
			label.textAlignment = .center
			return label
		}()

		let firstLabel: UILabel = {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.font = label.font.withSize(Sizes.Text.huge)
			label.textColor = Colors.Text.action
			label.text = "first"
			label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(first)))
			label.textAlignment = .center
			return label
		}()

		let orLabel: UILabel = {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.font = label.font.withSize(Sizes.Text.huge)
			label.textColor = Colors.Text.body
			label.text = "or"
			label.textAlignment = .center
			return label
		}()

		let secondLabel: UILabel = {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.font = label.font.withSize(Sizes.Text.huge)
			label.textColor = Colors.Text.action
			label.text = "second?"
			label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(second)))
			label.textAlignment = .center
			return label
		}()

		view.addSubview(willYouGoLabel)
		view.addSubview(firstLabel)
		view.addSubview(orLabel)
		view.addSubview(secondLabel)

		NSLayoutConstraint.activate([
			willYouGoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			willYouGoLabel.bottomAnchor.constraint(equalTo: firstLabel.topAnchor, constant: -Sizes.Margins.small),

			firstLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			firstLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -Sizes.Margins.smaller),

			orLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			orLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: Sizes.Margins.smaller),

			secondLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			secondLabel.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: Sizes.Margins.small),
			])
	}


	@objc private func first() {

	}

	@objc private func second() {

	}
}

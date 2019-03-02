//
//  GameSettingsViewController.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-02-27.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

class GameSettingsViewController: UIViewController {

	private let fontSize: CGFloat = 44.0

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

		let willYouGoLabel = UILabel()
		willYouGoLabel.translatesAutoresizingMaskIntoConstraints = false
		willYouGoLabel.font = willYouGoLabel.font.withSize(fontSize)
		willYouGoLabel.textColor = Colors.Text.body
		willYouGoLabel.text = "Will you go"
		willYouGoLabel.textAlignment = .center
		view.addSubview(willYouGoLabel)

		let firstLabel = UILabel()
		firstLabel.translatesAutoresizingMaskIntoConstraints = false
		firstLabel.font = firstLabel.font.withSize(fontSize)
		firstLabel.textColor = Colors.Text.action
		firstLabel.text = "first"
		firstLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(first)))
		firstLabel.textAlignment = .center
		firstLabel.isUserInteractionEnabled = true
		view.addSubview(firstLabel)

		let orLabel = UILabel()
		orLabel.translatesAutoresizingMaskIntoConstraints = false
		orLabel.font = orLabel.font.withSize(fontSize)
		orLabel.textColor = Colors.Text.body
		orLabel.text = "or"
		orLabel.textAlignment = .center
		view.addSubview(orLabel)

		let secondLabel = UILabel()
		secondLabel.translatesAutoresizingMaskIntoConstraints = false
		secondLabel.font = secondLabel.font.withSize(fontSize)
		secondLabel.textColor = Colors.Text.action
		secondLabel.text = "second?"
		secondLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(second)))
		secondLabel.textAlignment = .center
		secondLabel.isUserInteractionEnabled = true
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
		beginGame(playerIsFirst: true)
	}

	@objc private func second() {
		beginGame(playerIsFirst: false)
	}

	private func beginGame(playerIsFirst: Bool) {
		let controller = GameplayViewController(api: api, playerIsFirst: playerIsFirst)
		show(controller, sender: self)
	}
}

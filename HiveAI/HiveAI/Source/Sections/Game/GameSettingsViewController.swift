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

		let willYouGoLabel = createBasicLabel(color: Colors.Text.body, text: "Will you go")
		view.addSubview(willYouGoLabel)

		let firstLabel = createBasicLabel(color: Colors.Text.action, text: "first")
		firstLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(first)))
		firstLabel.isUserInteractionEnabled = true
		view.addSubview(firstLabel)

		let orLabel = createBasicLabel(color: Colors.Text.body, text: "or")
		view.addSubview(orLabel)

		let secondLabel = createBasicLabel(color: Colors.Text.action, text: "second?")
		secondLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(second)))
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
			secondLabel.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: Sizes.Margins.small)
			])
	}

	private func createBasicLabel(color: UIColor, text: String) -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = label.font.withSize(fontSize)
		label.textAlignment = .center
		label.textColor = color
		label.text = text
		return label
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

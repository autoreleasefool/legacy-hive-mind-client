//
//  HomeViewController.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

	private var winner: Player?

	private let winnerImage = UIImageView()
	private let winnerName = UILabel()
	private let newGameButton = UIButton()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = Colors.background

		newGameButton.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(newGameButton)
		NSLayoutConstraint.activate([
			newGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			newGameButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
			])

		newGameButton.setTitleColor(Colors.Text.body, for: .normal)
		newGameButton.setTitle("NEW GAME", for: .normal)
		newGameButton.addTarget(self, action: #selector(newGame), for: .touchUpInside)
	}

	private func update() {
		print("Winner: \(winner)")
	}

	@objc private func newGame() {
		let gameViewController = GameViewController(endGameCallback: { [weak self] winner in
			self?.winner = winner
			self?.update()
		})
		let navigationController = UINavigationController(rootViewController: gameViewController)
		present(navigationController, animated: true)
	}
}

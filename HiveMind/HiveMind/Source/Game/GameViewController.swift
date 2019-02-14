//
//  GameViewController.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

class GameViewController: UIViewController {

	private let endGameCallback: (_ winner: Player) -> Void

	private var state: ClientGameState? = nil
	private var settingsOpen: Bool = false
	private var selectedMovementType: MovementType? = nil

	private let tableView = UITableView()
	private let tableData = FunctionalTableData()

	init(endGameCallback: @escaping (_ winner: Player) -> Void) {
		self.endGameCallback = endGameCallback
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tableView)

		tableData.tableView = self.tableView

		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			])
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		render()

		if state == nil && !settingsOpen {
			openGameSettings()
		}
	}

	private func beginGame() {
		render()
	}

	private func openGameSettings() {
		let settings = GameSettingsViewController() { [weak self] state in
			self?.state = state
			self?.settingsOpen = false
			self?.render()
		}

		self.settingsOpen = true
		let navigationController = UINavigationController(rootViewController: settings)
		present(navigationController, animated: true)
	}

	private func render() {
		if let state = state {
			if state.isAITurn {
				self.title = "HiveMind's Turn"
			} else {
				self.title = "Player's Turn"
			}
		} else {
			self.title = "New Game"
		}

		tableData.renderAndDiff(GameBuilder.sections(state: state, selectedMovementType: selectedMovementType, actionable: self))
	}
}

extension GameViewController: GameActionable {
	func selected(movement: Movement) {
		self.state!.state = self.state!.state.apply(movement)
		// TODO: launch request
		self.render()
	}

	func selected(movementType: MovementType) {
		self.selectedMovementType = movementType
		self.render()
	}

	func cancel() {
		self.selectedMovementType = nil
		self.render()
	}

	func moveAccepted(movement: Movement) {
		self.state!.state = self.state!.state.apply(movement)
		self.state?.aiMove = nil
		self.render()
	}
}

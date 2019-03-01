//
//  GameplayViewController.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-27.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import HiveEngine
import FunctionalTableData

class GameplayViewController: UIViewController {

	struct State {
		let aiPlayer: Player
		var gameState: GameState = GameState()

		var lastAiMove: Movement?

		var availableMoves: [Movement] = []
		var selectedMovementCategory: MovementCategory?
		var selectedUnitId: UUID?

		var isPlayerTurn: Bool {
			return gameState.currentPlayer != aiPlayer
		}

		init(playerIsFirst: Bool) {
			self.aiPlayer = playerIsFirst ? .black : .white
		}
	}

	private let api: HiveApi
	private var state: State

	private let tableView = UITableView()
	private let tableData = FunctionalTableData()

	init(api: HiveApi, playerIsFirst: Bool) {
		self.api = api
		self.state = State(playerIsFirst: playerIsFirst)
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = Colors.primary
		tableView.backgroundColor = Colors.primaryBackground

		tableView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tableView)
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leftAnchor.constraint(equalTo: view.leftAnchor)
			])

		tableData.tableView = tableView

		updateTitle()
		render()
	}

	private func updateTitle() {
		self.title = state.isPlayerTurn ? "Your Move" : "AI's Move"
	}

	private func render() {
		tableData.renderAndDiff(GameplayBuilder.sections(state: state, actionable: self))
	}
}

extension GameplayViewController: GameplayActionable {
	func confirmAiMove() {

	}

	func select(category: MovementCategory) {
		if state.selectedMovementCategory == category {
			state.selectedMovementCategory = nil
			state.selectedUnitId = nil
		} else {
			state.selectedMovementCategory = category
		}
		render()
	}

	func select(identifier: UUID) {
		if state.selectedUnitId == identifier {
			state.selectedUnitId = nil
		} else {
			state.selectedUnitId = identifier
		}
		render()
	}

	func select(position: Position) {

	}
}

//
//  GameplayViewController.swift
//  HiveAI
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
		var previousState: GameState?
		var gameState: GameState = GameState() {
			didSet {
				previousState = oldValue
			}
		}

		var lastAiMove: Movement?

		var availableMoves: [Movement] = []
		var selectedMovementCategory: MovementCategory?
		var selectedUnitId: UUID?
		var inputEnabled: Bool

		var isPlayerTurn: Bool {
			return gameState.currentPlayer != aiPlayer
		}

		var isAiTurn: Bool {
			return isPlayerTurn == false
		}

		init(playerIsFirst: Bool) {
			self.aiPlayer = playerIsFirst ? .black : .white
			self.inputEnabled = playerIsFirst ? true : false
		}

		mutating func clearSelection() {
			selectedMovementCategory = nil
			selectedUnitId = nil
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

		if state.isAiTurn {
			state.inputEnabled = false
			render()
		}

		api.newGame(playerIsFirst: state.isPlayerTurn, delegate: self)
	}

	private func updateTitle() {
		self.title = state.isPlayerTurn ? "Your Move" : "AI's Move"
	}

	private func render() {
		tableData.renderAndDiff(GameplayBuilder.sections(aiName: api.name, state: state, actionable: self))
	}

	private func resolvePlayerMovement(_ movement: Movement) {
		state.clearSelection()
		state.inputEnabled = false

		let newState = state.gameState.apply(movement)
		if newState.isEndGame {
			// TODO: end game
			return
		}

		if state.gameState != newState {
			state.gameState = newState
			updateTitle()
			api.play(in: state.gameState, delegate: self)
		} else {
			// TODO: popup message that move is invalid
			state.inputEnabled = true
		}

		render()
	}

	private func resolveAiMovement(_ movement: Movement) {
		state.gameState = state.gameState.apply(movement)
		state.clearSelection()
		state.lastAiMove = nil
		state.inputEnabled = true

		updateTitle()
		render()
	}
}

extension GameplayViewController: GameplayActionable {
	func confirmAiMove() {
		guard let aiMovement = state.lastAiMove else { return }
		resolveAiMovement(aiMovement)
	}

	func select(category: MovementCategory) {
		guard state.inputEnabled else { return }
		if state.selectedMovementCategory == category {
			state.selectedMovementCategory = nil
			state.selectedUnitId = nil
		} else {
			state.selectedMovementCategory = category
		}
		render()
	}

	func select(identifier: UUID) {
		guard state.inputEnabled else { return }
		if state.selectedUnitId == identifier {
			state.selectedUnitId = nil
		} else {
			state.selectedUnitId = identifier
		}
		render()
	}

	func select(movement: Movement) {
		guard state.inputEnabled else { return }
		resolvePlayerMovement(movement)
	}
}

extension GameplayViewController: HiveApiDelegate {
	func didBeginGame(api: HiveApi) {
		if state.isAiTurn {
			api.play(in: state.gameState, delegate: self)
		}
	}

	func didPlay(api: HiveApi, move: Movement) {
		state.lastAiMove = move
		state.inputEnabled = true
		render()
	}

	func didReceiveError(api: HiveApi, error: Error) {
		print(error)
	}
}

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

class GameplayViewController: FunctionalTableDataViewController {

	struct State {
		let aiPlayer: Player
		var gameState: GameState = GameState()

		var lastAiMove: Movement?

		var availableMoves: [Movement] = []
		var selectedMovementCategory: MovementCategory?
		var selectedUnit: HiveEngine.Unit?
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
			selectedUnit = nil
		}
	}

	private let api: HiveAPI
	private var state: State

	init(api: HiveAPI, playerIsFirst: Bool) {
		self.api = api
		self.state = State(playerIsFirst: playerIsFirst)
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigation()
		view.backgroundColor = Colors.primary

		if state.isAiTurn {
			state.inputEnabled = false
		}

		updateTitle()
		refresh()

		api.newGame(playerIsFirst: state.isPlayerTurn, delegate: self)
	}

	private func setupNavigation() {
		navigationItem.hidesBackButton = true
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(promptFinishGame))
	}

	private func updateTitle() {
		self.title = state.gameState.isEndGame ? "Game over!" : (state.isPlayerTurn ? "Your Move" : "AI's Move")
	}

	override func render() -> [TableSection] {
		return GameplayBuilder.sections(aiName: api.name, state: state, actionable: self)
	}

	private func resolvePlayerMovement(_ movement: Movement) {
		state.clearSelection()
		state.inputEnabled = false

		state.gameState.apply(movement)
		updateTitle()

		if state.gameState.isEndGame {
			// Do nothing
		} else if state.isAiTurn {
			api.play(movement, delegate: self)
		} else {
			state.inputEnabled = true
		}

		refresh()
	}

	private func resolveAiMovement(_ movement: Movement) {
		state.gameState.apply(movement)
		state.clearSelection()
		state.lastAiMove = nil

		if state.isAiTurn {
			state.inputEnabled = false
			api.play(nil, delegate: self)
		} else {
			state.inputEnabled = true
		}

		updateTitle()
		refresh()
	}

	@objc private func promptFinishGame() {
		DispatchQueue.main.async { [weak self] in
			let alert = UIAlertController(title: "Finish game?", message: "Are you sure you want to end this game? You'll lose all your progress.", preferredStyle: .alert)

			alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in })
			alert.addAction(UIAlertAction(title: "Finish", style: .destructive) { _ in
				self?.api.endGame()
				self?.navigationController?.popViewController(animated: true)
			})

			self?.present(alert, animated: true)
		}
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
			state.clearSelection()
		} else {
			state.selectedMovementCategory = category
		}
		refresh()
	}

	func select(unit: HiveEngine.Unit) {
		guard state.inputEnabled else { return }
		if state.selectedUnit == unit {
			state.selectedUnit = nil
		} else {
			state.selectedUnit = unit
		}
		refresh()
	}

	func select(movement: Movement) {
		guard state.inputEnabled else { return }
		resolvePlayerMovement(movement)
	}
}

extension GameplayViewController: HiveAPIDelegate {
	func didBeginGame(api: HiveAPI) {
		if state.isAiTurn {
			api.play(nil, delegate: self)
		}
	}

	func didPlay(api: HiveAPI, move: Movement) {
		state.lastAiMove = move
		state.inputEnabled = true
		refresh()
	}

	func didReceiveError(api: HiveAPI, error: Error) {
		DispatchQueue.main.async { [weak self] in
			print(error)
			let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
			self?.present(alert, animated: true)
		}
	}
}

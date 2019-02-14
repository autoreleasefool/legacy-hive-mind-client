//
//  ClientGameState.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

struct ClientGameState {

	let aiPlayer: Player
	private(set) var state: GameState

	init(aiPlayer: Player) {
		self.aiPlayer = aiPlayer
		self.state = GameState()
	}

	var isAITurn: Bool {
		return aiPlayer == state.currentPlayer
	}

}

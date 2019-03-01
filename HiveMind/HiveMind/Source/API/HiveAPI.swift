//
//  HiveAPI.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-27.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import HiveEngine

protocol HiveApiDelegate: class {
	func didPlay(api: HiveApi, move: Movement)
	func didBeginGame(api: HiveApi)
}

struct HiveApi: Codable {

	let name: String
	let description: String
	let iconName: String

	var icon: UIImage {
		return UIImage(named: iconName)!
	}

	func play(move: Movement, in state: GameState, completion: @escaping (Movement) -> Void) {

	}

	func newGame(playerIsFirst: Bool, completion: @escaping (Movement?) -> Void) {

	}
}
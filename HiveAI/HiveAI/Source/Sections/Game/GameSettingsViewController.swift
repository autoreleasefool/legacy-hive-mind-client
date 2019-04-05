//
//  GameSettingsViewController.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-02-27.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

class GameSettingsViewController: FunctionalTableDataViewController {

	/// Current API
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
		refresh()
	}

	override func render() -> [TableSection] {
		return GameSettingsBuilder.sections(actionable: self)
	}
}

// MARK: - GameSettingsActionable

extension GameSettingsViewController: GameSettingsActionable {
	func beginGame(playerIsFirst: Bool) {
		let controller = GameplayViewController(api: api, playerIsFirst: playerIsFirst)
		show(controller, sender: self)
	}
}

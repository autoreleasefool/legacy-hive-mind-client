//
//  GameSettingsViewController.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

class GameSettingsViewController: UIViewController {

	private let completion: (_ state: ClientGameState) -> Void

	private let tableView = UITableView()
	private let tableData = FunctionalTableData()

	private var aiIsFirst: Bool = false

	init(completion: (@escaping (_ state: ClientGameState) -> Void)) {
		self.completion = completion
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "New Game"

		tableView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tableView)

		tableData.tableView = self.tableView

		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
			])

		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didPressDone))
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		render()
	}

	private func render() {
		tableData.renderAndDiff(GameSettingsBuilder.sections(aiIsFirst: aiIsFirst, actionable: self))
	}

	@objc private func didPressDone() {
		let aiPlayer: Player = aiIsFirst ? .white : .black
		completion(ClientGameState(aiPlayer: aiPlayer))
		dismiss(animated: true)
	}
}

extension GameSettingsViewController: GameSettingsActionable {
	func setAITurn(isFirst: Bool) {
		self.aiIsFirst = isFirst
		render()
	}
}

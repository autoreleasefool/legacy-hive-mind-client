//
//  HomeViewController.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData
import HiveEngine

class AIListViewController: UIViewController {

	private let tableView = UITableView()
	private let tableData = FunctionalTableData()

	private var apis: [HiveApi] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Hive AI"

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

		render()
		loadApis()
	}

	private func loadApis() {
		guard let url = Bundle.main.url(forResource: "APIs", withExtension: "plist") else {
			fatalError("Failed to load APIs.plist")
		}

		if let apiData = try? Data(contentsOf: url) {
			let decoder = PropertyListDecoder()
			apis = try! decoder.decode([HiveApi].self, from: apiData)
			apis = apis.sorted(by: { $0.name < $1.name })
			render()
		}
	}

	private func render() {
		tableData.renderAndDiff(AIListBuilder.sections(apis: apis, actionable: self))
	}
}

extension AIListViewController: AIListActionable {
	func play(with api: HiveApi) {
		let controller = GameSettingsViewController(api: api)
		show(controller, sender: self)
	}
}

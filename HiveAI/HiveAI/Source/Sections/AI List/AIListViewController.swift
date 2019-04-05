//
//  HomeViewController.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-02-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData
import HiveEngine

class AIListViewController: FunctionalTableDataViewController {

	private var apis: [HiveApi] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Hive AI"
		view.backgroundColor = Colors.primary
		refresh()
		loadApis()
	}

	private func loadApis() {
		guard let url = Bundle.main.url(forResource: "APIs", withExtension: "plist") else {
			fatalError("Failed to load APIs.plist")
		}

		let decoder = PropertyListDecoder()
		if let apiData = try? Data(contentsOf: url), let apis = try? decoder.decode([HiveApi].self, from: apiData) {
			self.apis = apis.sorted(by: { $0.name < $1.name })
			refresh()
		}
	}

	override func render() -> [TableSection] {
		return AIListBuilder.sections(apis: apis, actionable: self)
	}
}

extension AIListViewController: AIListActionable {
	func play(with api: HiveApi) {
		let controller = GameSettingsViewController(api: api)
		show(controller, sender: self)
	}
}

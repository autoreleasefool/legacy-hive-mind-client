//
//  AIListViewModel.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-06-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import SwiftUI
import Combine

enum AIListViewAction: ViewAction {
	case `init`
	case aiSelected(ai: HiveAI)
}

final class AIListViewModel: ViewModel {
	let didChange = PassthroughSubject<Void, Never>()

	private(set) var ais: [HiveAI] {
		didSet {
			didChange.send(())
		}
	}

	init(ais: [HiveAI] = []) {
		self.ais = ais
		self.handleAction(AIListViewAction.`init`)
	}

	func handleAction(_ action: ViewAction) {
		guard let action = action as? AIListViewAction else { return }
		switch action {
		case .`init`:
			loadAIs()
		case .aiSelected(let ai):
			break
		}
	}

	private func loadAIs() {
		guard let url = Bundle.main.url(forResource: "AIList", withExtension: "plist") else {
			fatalError("Failed to load AIList.plist")
		}

		let decoder = PropertyListDecoder()
		if let aiData = try? Data(contentsOf: url), let ais = try? decoder.decode([HiveAI].self, from: aiData) {
			self.ais = ais.sorted(by: { $0.name < $1.name })
		}
	}
}

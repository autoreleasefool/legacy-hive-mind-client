//
//  GameSettingsBuilder.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-04-05.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

protocol GameSettingsActionable: class {
	func beginGame(playerIsFirst: Bool)
}

struct GameSettingsBuilder {
	enum Keys: String {
		case settingsSection
		case willYouGo
		case first
		case or
		case second
	}

	static func sections(actionable: GameSettingsActionable) -> [TableSection] {
		let rows: [CellConfigType] = [
			Cells.labelCell(key: Keys.willYouGo.rawValue, text: "Will you go"),
			Cells.labelCell(key: Keys.first.rawValue, text: "first", cellActions: CellActions(selectionAction: { [weak actionable] _ in
				actionable?.beginGame(playerIsFirst: true)
				return .deselected
			})),
			Cells.labelCell(key: Keys.or.rawValue, text: "or"),
			Cells.labelCell(key: Keys.second.rawValue, text: "second?", cellActions: CellActions(selectionAction: { [weak actionable] _ in
				actionable?.beginGame(playerIsFirst: false)
				return .deselected
			}))
		]

		return [TableSection(key: Keys.settingsSection, rows: rows)]
	}

	struct Cells {
		static func labelCell(key: String, text: String, cellActions: CellActions? = nil) -> CellConfigType {
			let textColor = cellActions != nil ? Colors.Text.action : Colors.Text.body

			return LabelCell(
				key: key,
				style: CellStyle.default,
				actions: cellActions ?? CellActions(),
				state: LabelState(text: text, fontSize: Sizes.Text.display, textColor: textColor, alignment: .center),
				cellUpdater: LabelState.updateView
			)
		}
	}
}

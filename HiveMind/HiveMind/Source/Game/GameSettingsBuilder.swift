//
//  GameSettingsBuilder.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import FunctionalTableData

protocol GameSettingsActionable: class {
	func setAITurn(isFirst: Bool)
}

struct GameSettingsBuilder {
	enum Keys: String {
		case settings
		enum Settings: String {
			case opponentName
			case aiColor
			case aiTurn
		}
	}

	static func sections(aiIsFirst: Bool, actionable: GameSettingsActionable) -> [TableSection] {
		let colorCell = ValueCell(
			key: Keys.Settings.aiColor.rawValue,
			style: CellStyle(bottomSeparator: .inset, separatorColor: Colors.divider),
			state: ValueCellState(title: "AI Color", subtitle: Player.white.rawValue),
			cellUpdater: ValueCellState.updateView
		)

		let turnCell = SwitchCell(
			key: Keys.Settings.aiTurn.rawValue,
			style: CellStyle(bottomSeparator: .inset, separatorColor: Colors.divider, highlight: true),
			actions: CellActions(selectionAction: { [weak actionable] _ in
				actionable?.setAITurn(isFirst: !aiIsFirst)
				return .deselected
			}),
			state: SwitchCellState(title: "AI First", isOn: aiIsFirst),
			cellUpdater: SwitchCellState.viewUpdater
		)

		return [TableSection(
			key: Keys.settings.rawValue,
			rows: [colorCell, turnCell],
			style: SectionStyle(separators: .default)
		)]
	}
}

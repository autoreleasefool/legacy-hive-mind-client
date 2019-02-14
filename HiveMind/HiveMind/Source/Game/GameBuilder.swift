//
//  GameViewBuilder.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import FunctionalTableData

protocol GameActionable: class {
	func selected(movementType: MovementType)
	func selected(movement: Movement)
	func cancel()
}

enum MovementType: String, CaseIterable {
	case move = "Move"
	case place = "Place"
	case yoink = "Yoink"
}

extension Movement {
	var type: MovementType {
		switch self {
		case .move: return .move
		case .place: return .place
		case .yoink: return .yoink
		}
	}
}


struct GameBuilder {
	enum Keys: String {
		case movementTypes
		case movements
		case cancel
	}

	static func sections(state: ClientGameState?, selectedMovementType: MovementType?, actionable: GameActionable) -> [TableSection] {
		guard let state = state else { return [] }

		if let movementType = selectedMovementType {
			return movementsSection(state: state, selectedMovementType: movementType, actionable: actionable)
		} else {
			return movementTypesSection(actionable: actionable)
		}
	}

	static func movementTypesSection(actionable: GameActionable) -> [TableSection] {
		let rows: [CellConfigType] = MovementType.allCases.map { type in
			LabelCell(
				key: "\(Keys.movementTypes)-\(type)",
				style: CellStyle(bottomSeparator: .inset, separatorColor: Colors.divider, highlight: true, accessoryType: .disclosureIndicator),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.selected(movementType: type)
					return .deselected
				}),
				state: LabelState(title: type.rawValue, fontSize: Text.Size.body),
				cellUpdater: LabelState.updateView
			)
		}

		return [
			TableSection(
				key: Keys.movementTypes,
				rows: rows,
				style: SectionStyle(separators: .default)
			)
		]
	}

	static func movementsSection(state: ClientGameState, selectedMovementType: MovementType, actionable: GameActionable) -> [TableSection] {
		var rows: [CellConfigType] = state.state.availableMoves
			.filter { $0.type == selectedMovementType }
			.map { movement in
				MovementCell(
					key: "\(Keys.movements)-\(movement)",
					style: CellStyle(bottomSeparator: .inset, separatorColor: Colors.divider, highlight: true),
					actions: CellActions(selectionAction: { [weak actionable] _ in
						actionable?.selected(movement: movement)
						return .deselected
					}),
					state: MovementCellState(movement: movement),
					cellUpdater: MovementCellState.updateView
				)
			}

		rows.insert(
			LabelCell(
				key: Keys.cancel.rawValue,
				style: CellStyle(bottomSeparator: .inset, separatorColor: Colors.divider, highlight: true),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.cancel()
					return .deselected
				}),
				state: LabelState(title: "Cancel", fontSize: Text.Size.subtitle),
				cellUpdater: LabelState.updateView
			), at: 0)

		return [
			TableSection(
				key: Keys.movements,
				rows: rows
			)
		]
	}
}
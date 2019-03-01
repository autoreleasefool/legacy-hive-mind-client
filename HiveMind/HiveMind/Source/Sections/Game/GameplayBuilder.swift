//
//  GameplayBuilder.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-27.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData
import HiveEngine

protocol GameplayActionable: class {
	func confirmAiMove()
	func select(category: MovementCategory)
	func select(identifier: UUID)
	func select(position: Position)
}

struct GameplayBuilder {
	private static let selectedFontSize: CGFloat = 24.0
	private static let titleFontSize: CGFloat = 20.0
	private static let imageSize: CGFloat = 44.0

	private enum Keys: String {
		case playerSelection
		enum PlayerSelection: String {
			case titleLabel
			case movementCell
			case ownerLabel
			case unitCell
			case prepositionLabel
			case positionCell
			case confirmButton
		}

		case movements
		case units
		case positions

		static func `for`(category: MovementCategory) -> String {
			return "\(Keys.PlayerSelection.movementCell).\(category)"
		}

		static func `for`(unit: HiveEngine.Unit) -> String {
			return "\(Keys.PlayerSelection.unitCell).\(unit.identifier.uuidString)"
		}
	}

	static func sections(state: GameplayViewController.State, actionable: GameplayActionable) -> [TableSection] {
		if state.isPlayerTurn {
			return [
				playerSelectionSection(state: state, actionable: actionable),
				playerSection(state: state, actionable: actionable)
			]
		} else {
			return []// [aiSections(state: state, actionable: actionable)]
		}
	}

	// MARK: - Player

	static func playerSelectionSection(state: GameplayViewController.State, actionable: GameplayActionable) -> TableSection {
		var rows: [CellConfigType] = []
		rows.append(Cells.selectionTextCell(key: Keys.PlayerSelection.titleLabel.rawValue, text: "I want to"))

		if let category = state.selectedMovementCategory {
			rows.append(Cells.categoryCell(for: category, selected: true, actionable: actionable))

			switch category {
			case .move, .place: rows.append(Cells.selectionTextCell(key: Keys.PlayerSelection.ownerLabel.rawValue, text: "my"))
			case .yoink: rows.append(Cells.selectionTextCell(key: Keys.PlayerSelection.ownerLabel.rawValue, text: "the"))
			}

			if let unitId = state.selectedUnitId, let unit = state.gameState.find(id: unitId) {
				rows.append(Cells.unitCell(for: unit, selected: true, actionable: actionable))

				switch category {
				case .move, .yoink: rows.append(Cells.selectionTextCell(key: Keys.PlayerSelection.prepositionLabel.rawValue, text: "to"))
				case .place: rows.append(Cells.selectionTextCell(key: Keys.PlayerSelection.prepositionLabel.rawValue, text: "at"))
				}
			}
		}

		return TableSection(key: Keys.playerSelection, rows: rows)
	}

	static func playerSection(state: GameplayViewController.State, actionable: GameplayActionable) -> TableSection {
		if let category = state.selectedMovementCategory {
			if let unit = state.selectedUnitId {
				return positionsSection(state: state, actionable: actionable)
			}
			return unitsSection(state: state, actionable: actionable)
		} else {
			return movementsSection(state: state, actionable: actionable)
		}
	}

	static func movementsSection(state: GameplayViewController.State, actionable: GameplayActionable) -> TableSection {
		let availableCategories: Set<MovementCategory> = Set(state.gameState.availableMoves.map { MovementCategory.from($0) })
		let rows: [CellConfigType] = availableCategories.sorted(by: { $0.rawValue < $1.rawValue }).map {
			return Cells.categoryCell(for: $0, selected: false, actionable: actionable)
		}

		return TableSection(key: Keys.movements, rows: rows, style: SectionStyle(separators: .default))
	}

	static func unitsSection(state: GameplayViewController.State, actionable: GameplayActionable) -> TableSection {
		let availableUnits: Set<HiveEngine.Unit> = Set(state.gameState.availableMoves.compactMap {
			guard MovementCategory.from($0) == state.selectedMovementCategory else { return nil }
			return $0.movedUnit
		})

		let rows: [CellConfigType] = availableUnits.sorted(by: { $0.class.rawValue < $1.class.rawValue }).map {
			return Cells.unitCell(for: $0, selected: false, actionable: actionable)
		}

		return TableSection(key: Keys.units, rows: rows)
	}

	static func positionsSection(state: GameplayViewController.State, actionable: GameplayActionable) -> TableSection {
		return TableSection(key: Keys.positions, rows: [])
	}

	// MARK: - AI

	// MARK: - Cells

	struct Cells {
		static func selectionTextCell(key: String, text: String) -> CellConfigType {
			return LabelCell(
				key: key,
				style: CellStyle(separatorColor: Colors.separator, highlight: true, backgroundColor: Colors.primary),
				state: LabelState(text: text, fontSize: GameplayBuilder.selectedFontSize),
				cellUpdater: LabelState.updateView
			)
		}

		static func categoryCell(for category: MovementCategory, selected: Bool, actionable: GameplayActionable) -> CellConfigType {
			let backgroundColor: UIColor?
			let fontSize: CGFloat
			let text: String
			if selected {
				backgroundColor = Colors.primary
				fontSize = GameplayBuilder.selectedFontSize
				text = category.rawValue.lowercased()
			} else {
				backgroundColor = nil
				fontSize = GameplayBuilder.titleFontSize
				text = category.rawValue
			}

			return ImageLabelCell(
				key: Keys.for(category: category),
				style: CellStyle(separatorColor: Colors.separator, highlight: true, backgroundColor: backgroundColor),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.select(category: category)
					return .deselected
				}),
				state: ImageLabelCellState(text: text, image: category.image, fontSize: fontSize, imageWidth: GameplayBuilder.imageSize, imageHeight: GameplayBuilder.imageSize),
				cellUpdater: ImageLabelCellState.updateView
			)
		}

		static func unitCell(for unit: HiveEngine.Unit, selected: Bool, actionable: GameplayActionable) -> CellConfigType {
			let backgroundColor: UIColor?
			let fontSize: CGFloat
			let text: String
			if selected {
				backgroundColor = Colors.primary
				fontSize = GameplayBuilder.selectedFontSize
				text = unit.description.lowercased()
			} else {
				backgroundColor = nil
				fontSize = GameplayBuilder.titleFontSize
				text = unit.description
			}

			return ImageDetailCell(
				key: Keys.for(unit: unit),
				style: CellStyle(separatorColor: Colors.separator, highlight: true, backgroundColor: backgroundColor),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.select(identifier: unit.identifier)
					return .deselected
				}),
				state: ImageDetailCellState(title: unit.description, description: unit.identifier.uuidString, icon: unit.image, imageWidth: GameplayBuilder.imageSize, imageHeight: GameplayBuilder.imageSize),
				cellUpdater: ImageDetailCellState.updateView
			)
		}
	}
}

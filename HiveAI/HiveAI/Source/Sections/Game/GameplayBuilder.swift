//
//  GameplayBuilder.swift
//  HiveAI
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
	func select(movement: Movement)
}

struct GameplayBuilder {
	private static let imageSize: CGFloat = 44.0

	private enum Keys: String {
		case loading
		enum Loading: String {
			case loadingView
		}

		case playerSelection
		enum PlayerSelection: String {
			case titleLabel
			case movementCell
			case ownerLabel
			case unitCell
			case prepositionLabel
			case positionCell
		}

		case aiSection
		enum AiSection: String {
			case titleLabel
			case movementCell
			case ownerLabel
			case unitCell
			case prepositionLabel
			case positionCell
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

		static func `for`(movement: Movement) -> String {
			return "\(Keys.PlayerSelection.positionCell).\(movement)"
		}
	}

	static func sections(aiName: String, state: GameplayViewController.State, actionable: GameplayActionable) -> [TableSection] {
		if state.inputEnabled == false {
			return [loadingSection()]
		} else if state.isPlayerTurn {
			return [
				playerSelectionSection(state: state, actionable: actionable),
				playerSection(state: state, actionable: actionable)
			]
		} else {
			return [aiSection(aiName: aiName, state: state, actionable: actionable)].compactMap { $0 }
		}
	}

	// MARK - Loading

	static func loadingSection() -> TableSection {
		let rows: [CellConfigType] = [
			SpinnerCell(key: Keys.Loading.loadingView, state: SpinnerState(isLoading: true), cellUpdater: SpinnerState.updateView)
		]
		return TableSection(key: Keys.loading, rows: rows, style: SectionStyle(separators: .topAndBottom))
	}

	// MARK: - AI

	static func aiSection(aiName: String, state: GameplayViewController.State, actionable: GameplayActionable) -> TableSection? {
		guard let aiMove = state.lastAiMove else { return nil }
		let category = MovementCategory.from(aiMove)
		let unit = aiMove.movedUnit
		let previousPosition = state.previousState?.units[unit] ?? .inHand

		var rows: [CellConfigType] = [
			Cells.selectionTextCell(key: Keys.AiSection.titleLabel.rawValue, text: "\(aiName) will", ai: true, actionable: actionable),
			Cells.categoryCell(for: category, selected: true, ai: true, actionable: actionable)
		]

		switch category {
		case .move, .place: rows.append(Cells.selectionTextCell(key: Keys.PlayerSelection.ownerLabel.rawValue, text: "their", ai: true, actionable: actionable))
		case .yoink: rows.append(Cells.selectionTextCell(key: Keys.PlayerSelection.ownerLabel.rawValue, text: "the", ai: true, actionable: actionable))
		}

		rows.append(Cells.unitCell(for: unit, at: previousPosition, selected: true, ai: true, actionable: actionable))

		switch category {
		case .move, .yoink: rows.append(Cells.selectionTextCell(key: Keys.AiSection.prepositionLabel.rawValue, text: "to", ai: true, actionable: actionable))
		case .place: rows.append(Cells.selectionTextCell(key: Keys.AiSection.prepositionLabel.rawValue, text: "at", ai: true, actionable: actionable))
		}

		rows.append(Cells.positionCell(for: aiMove, selected: true, ai: true, actionable: actionable))

		return TableSection(key: Keys.aiSection, rows: rows)
	}

	// MARK: - Player

	static func playerSelectionSection(state: GameplayViewController.State, actionable: GameplayActionable) -> TableSection {
		var rows: [CellConfigType] = []
		rows.append(Cells.selectionTextCell(key: Keys.PlayerSelection.titleLabel.rawValue, text: "I want to", actionable: actionable))

		if let category = state.selectedMovementCategory {
			rows.append(Cells.categoryCell(for: category, selected: true, actionable: actionable))

			switch category {
			case .move, .place: rows.append(Cells.selectionTextCell(key: Keys.PlayerSelection.ownerLabel.rawValue, text: "my", actionable: actionable))
			case .yoink: rows.append(Cells.selectionTextCell(key: Keys.PlayerSelection.ownerLabel.rawValue, text: "the", actionable: actionable))
			}

			if let unitId = state.selectedUnitId, let unit = state.gameState.find(id: unitId), let position = state.gameState.units[unit] {
				rows.append(Cells.unitCell(for: unit, at: position, selected: true, actionable: actionable))

				switch category {
				case .move, .yoink: rows.append(Cells.selectionTextCell(key: Keys.PlayerSelection.prepositionLabel.rawValue, text: "to", actionable: actionable))
				case .place: rows.append(Cells.selectionTextCell(key: Keys.PlayerSelection.prepositionLabel.rawValue, text: "at", actionable: actionable))
				}
			}
		}

		return TableSection(key: Keys.playerSelection, rows: rows)
	}

	static func playerSection(state: GameplayViewController.State, actionable: GameplayActionable) -> TableSection {
		if state.selectedMovementCategory != nil {
			if state.selectedUnitId != nil {
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

		let rows: [CellConfigType] = availableUnits.sorted(by: { $0.class.rawValue < $1.class.rawValue }).compactMap {
			guard let position = state.gameState.units[$0] else { return nil }
			return Cells.unitCell(for: $0, at: position, selected: false, actionable: actionable)
		}

		return TableSection(key: Keys.units, rows: rows, style: SectionStyle(separators: .default))
	}

	static func positionsSection(state: GameplayViewController.State, actionable: GameplayActionable) -> TableSection {
		let availableMovements: Set<Movement> = Set(state.gameState.availableMoves.compactMap {
			guard MovementCategory.from($0) == state.selectedMovementCategory,
				$0.movedUnit.identifier == state.selectedUnitId else { return nil }
			return $0
		})

		let rows: [CellConfigType] = availableMovements.sorted(by: Movement.naturalSort).map { Cells.positionCell(for: $0, selected: false, actionable: actionable)}
		return TableSection(key: Keys.positions, rows: rows, style: SectionStyle(separators: .default))
	}

	// MARK: - AI

	// MARK: - Cells

	struct Cells {
		static func selectionTextCell(key: String, text: String, ai: Bool = false, actionable: GameplayActionable) -> CellConfigType {
			return LabelCell(
				key: key,
				style: CellStyle(separatorColor: Colors.separator, highlight: ai, backgroundColor: Colors.secondary),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					if ai {
						actionable?.confirmAiMove()
					}
					return .deselected
				}),
				state: LabelState(text: text, fontSize: Sizes.Text.title),
				cellUpdater: LabelState.updateView
			)
		}

		static func categoryCell(for category: MovementCategory, selected: Bool, ai: Bool = false, actionable: GameplayActionable) -> CellConfigType {
			let backgroundColor: UIColor?
			let text: String
			if selected {
				backgroundColor = Colors.secondary
				text = category.rawValue.lowercased()
			} else {
				backgroundColor = nil
				text = category.rawValue
			}

			return ImageLabelCell(
				key: Keys.for(category: category),
				style: CellStyle(separatorColor: Colors.separator, highlight: true, backgroundColor: backgroundColor),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					if ai {
						actionable?.confirmAiMove()
					} else {
						actionable?.select(category: category)
					}
					return .deselected
				}),
				state: ImageLabelCellState(text: text, image: category.image, fontSize: Sizes.Text.title, imageWidth: GameplayBuilder.imageSize, imageHeight: GameplayBuilder.imageSize),
				cellUpdater: ImageLabelCellState.updateView
			)
		}

		static func unitCell(for unit: HiveEngine.Unit, at position: Position, selected: Bool, ai: Bool = false, actionable: GameplayActionable) -> CellConfigType {
			let backgroundColor: UIColor?
			let text: String
			if selected {
				backgroundColor = Colors.secondary
				text = unit.description.lowercased()
			} else {
				backgroundColor = nil
				text = unit.description
			}

			return ImageDetailCell(
				key: Keys.for(unit: unit),
				style: CellStyle(separatorColor: Colors.separator, highlight: true, backgroundColor: backgroundColor),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					if ai {
						actionable?.confirmAiMove()
					} else {
						actionable?.select(identifier: unit.identifier)
					}
					return .deselected
				}),
				state: ImageDetailCellState(title: text, description: "from \(position.description.lowercased())", icon: unit.image, imageWidth: GameplayBuilder.imageSize, imageHeight: GameplayBuilder.imageSize),
				cellUpdater: ImageDetailCellState.updateView
			)
		}

		static func positionCell(for movement: Movement, selected: Bool, ai: Bool = false, actionable: GameplayActionable) -> CellConfigType {
			let backgroundColor: UIColor?
			if selected {
				backgroundColor = Colors.secondary
			} else {
				backgroundColor = nil
			}

			return ImageLabelCell(
				key: Keys.for(movement: movement),
				style: CellStyle(separatorColor: Colors.separator, highlight: true, backgroundColor: backgroundColor),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					if ai {
						actionable?.confirmAiMove()
					} else {
						actionable?.select(movement: movement)
					}
					return .deselected
				}),
				state: ImageLabelCellState(text: movement.targetPosition.description, image: Asset.position.image, fontSize: Sizes.Text.title, imageWidth: GameplayBuilder.imageSize, imageHeight: GameplayBuilder.imageSize),
				cellUpdater: ImageLabelCellState.updateView
			)
		}
	}
}

//
//  AIListBuilder.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-27.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import FunctionalTableData

protocol AIListActionable: class {
	func play(with api: HiveApi)
}

struct AIListBuilder {

	static func sections(apis: [HiveApi], actionable: AIListActionable) -> [TableSection] {
		let rows: [CellConfigType] = apis.map { Cells.apiCell(for: $0, actionable: actionable) }
		return [TableSection(key: "HiveApis", rows: rows, style: SectionStyle(separators: .default))]
	}

	struct Cells {
		static func apiCell(for api: HiveApi, actionable: AIListActionable) -> CellConfigType {
			return HiveApiCell(
				key: api.name,
				style: .default,
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.play(with: api)
					return .deselected
				}),
				state: HiveApiCellState(title: api.name, description: api.description, icon: api.icon),
				cellUpdater: HiveApiCellState.updateView
			)
		}
	}

}

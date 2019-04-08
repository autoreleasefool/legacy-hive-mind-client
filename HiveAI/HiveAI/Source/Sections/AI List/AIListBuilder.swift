//
//  AIListBuilder.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-02-27.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import FunctionalTableData

protocol AIListActionable: class {
	func play(with api: HiveAPI)
}

struct AIListBuilder {

	static func sections(apis: [HiveAPI], actionable: AIListActionable) -> [TableSection] {
		let rows: [CellConfigType] = apis.map { Cells.apiCell(for: $0, actionable: actionable) }
		return [TableSection(key: "HiveAPIs", rows: rows, style: SectionStyle(separators: .default))]
	}

	struct Cells {
		static func apiCell(for api: HiveAPI, actionable: AIListActionable) -> CellConfigType {
			return ImageDetailCell(
				key: api.name,
				style: .default,
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.play(with: api)
					return .deselected
				}),
				state: ImageDetailCellState(title: api.name, description: api.description, icon: api.icon),
				cellUpdater: ImageDetailCellState.updateView
			)
		}
	}

}

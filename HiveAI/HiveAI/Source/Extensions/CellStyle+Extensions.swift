//
//  CellStyle+Extensions.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-02-27.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import FunctionalTableData

extension CellStyle {
	/// Default CellStyle
	static var `default`: CellStyle {
		return CellStyle(separatorColor: Colors.separator, highlight: true)
	}
}

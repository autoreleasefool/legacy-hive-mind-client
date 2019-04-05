//
//  FunctionalTableDataViewController
//  HiveAI
//
//  Created by Joseph Roque on 2019-04-05.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

class FunctionalTableDataViewController: UIViewController {

	/// Primary UITableView for the layout
	private let tableView = UITableView()
	/// Primary FunctionalTableData for building the layout
	private let tableData = FunctionalTableData()

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.backgroundColor = Colors.primaryBackground

		tableView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tableView)
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leftAnchor.constraint(equalTo: view.leftAnchor)
			])

		tableData.tableView = tableView
	}

	/// Refresh the screen
	func refresh() {
		let sections = render()
		tableData.renderAndDiff(sections)
	}

	/// Build the cells to be rendered
	open func render() -> [TableSection] {
		fatalError("Must be overridden")
	}
}

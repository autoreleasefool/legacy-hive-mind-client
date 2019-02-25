//
//  MovementCell.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import FunctionalTableData

typealias MovementCell = HostCell<MovementCellView, MovementCellState, LayoutMarginsTableItemLayout>

class MovementCellView: UIView {

	fileprivate let image = UIImageView()
	fileprivate let unit = UILabel()
	fileprivate let position = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupViews() {
		image.translatesAutoresizingMaskIntoConstraints = false
		addSubview(image)

		unit.translatesAutoresizingMaskIntoConstraints = false
		addSubview(unit)

		position.translatesAutoresizingMaskIntoConstraints = false
		position.font = UIFont(name: position.font.fontName, size: Text.Size.caption)
		position.textColor = Colors.Text.caption
		addSubview(position)

		NSLayoutConstraint.activate([
			image.topAnchor.constraint(equalTo: topAnchor),
			image.bottomAnchor.constraint(equalTo: bottomAnchor),
			image.leadingAnchor.constraint(equalTo: leadingAnchor),
			image.heightAnchor.constraint(equalToConstant: 150.0),
			image.widthAnchor.constraint(equalToConstant: 150.0),

			unit.topAnchor.constraint(equalTo: image.topAnchor),
			unit.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: Margins.Size.base),

			position.topAnchor.constraint(equalTo: unit.bottomAnchor, constant: Margins.Size.small),
			position.leadingAnchor.constraint(equalTo: unit.leadingAnchor)
			])
	}

	fileprivate func prepareForReuse() {
		image.image = nil
		unit.text = nil
		position.text = nil
	}
}

struct MovementCellState: Equatable {

	let movement: Movement

	init(movement: Movement) {
		self.movement = movement
	}

	static func updateView(_ view: MovementCellView, state: MovementCellState?) {
		guard let state = state else {
			view.prepareForReuse()
			return
		}

		switch state.movement {
		case .move(let unit, let to):
			view.image.image = unit.image
			view.unit.text = "Move \(unit.class.rawValue.capitalizeFirst())"
			view.position.text = to.toString()
		case .place(let unit, let at):
			view.image.image = unit.image
			view.unit.text = "Place \(unit.class.rawValue.capitalizeFirst())"
			view.position.text = at.toString()
		case .yoink(_, let unit, let to):
			view.image.image = unit.image
			view.unit.text = "Yoink \(unit.class.rawValue.capitalizeFirst())"
			view.position.text = to.toString()
		}
	}

}

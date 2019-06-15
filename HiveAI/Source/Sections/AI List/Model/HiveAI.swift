//
//  AI.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-06-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import SwiftUI

enum HiveAIError: LocalizedError {
	/// No data was received in response to a request
	case noData
	/// The data from a response failed to be encoded to `type`
	case encodingFailure(type: Any.Type)

	var errorDescription: String? {
		switch self {
		case .noData: return "No data was received from the server."
		case .encodingFailure(let type): return "Value '\(type)' could not be converted to data."
		}
	}
}

struct HiveAI: Decodable {
	enum CodingKeys: String, CodingKey {
		case name
		case description
		case icon
		case endpoint
	}

	let name: String
	let description: String
	let icon: UIImage
	let endpoint: String

	init(name: String, description: String, iconName: String, endpoint: String) {
		self.name = name
		self.description = description
		self.icon = UIImage(named: iconName)!
		self.endpoint = endpoint
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)

		name = try values.decode(String.self, forKey: .name)
		description = try values.decode(String.self, forKey: .description)
		endpoint = try values.decode(String.self, forKey: .endpoint)

		let iconName = try values.decode(String.self, forKey: .icon)
		icon = UIImage(named: iconName)!
	}
}

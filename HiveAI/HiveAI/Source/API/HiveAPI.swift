//
//  HiveAPI.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-02-27.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import HiveEngine

enum ApiError: Error {
	case noData
	case dataEncodingFailure(type: Any.Type)
}

extension ApiError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .noData: return "No data was received from the server."
		case .dataEncodingFailure(let type): return "Value '\(type)' could not be converted to data."
		}
	}
}

protocol HiveApiDelegate: class {
	func didPlay(api: HiveApi, move: Movement)
	func didBeginGame(api: HiveApi)
	func didReceiveError(api: HiveApi, error: Error)
}

class HiveApi: Codable {

	let name: String
	let description: String
	let iconName: String
	let endpoint: String

	var icon: UIImage {
		return UIImage(named: iconName)!
	}

	var endpointURL: URL {
		return URL(string: endpoint)!
	}

	var playURL: URL {
		return endpointURL.appendingPathComponent("play")
	}

	var newGameURL: URL {
		return endpointURL.appendingPathComponent("new")
	}

	func play(_ move: Movement?, delegate: HiveApiDelegate) {
		var request = URLRequest(url: playURL)
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.timeoutInterval = 30

		if let move = move {
			let encoder = JSONEncoder()
			let data: Data
			do {
				data = try encoder.encode(move)
			} catch {
				delegate.didReceiveError(api: self, error: error)
				return
			}

			request.httpBody = data
		}

		let task = URLSession.shared.dataTask(with: request) { [weak self, weak delegate] data, _, error in
			guard let self = self, let delegate = delegate else { return }
			self.parseApiResponse(data: data, error: error, delegate: delegate)
		}
		task.resume()
	}

	func newGame(playerIsFirst: Bool, delegate: HiveApiDelegate) {
		let jsonString = "{\"playerIsFirst\": \(playerIsFirst)}"
		guard let data = jsonString.data(using: .utf8) else {
			delegate.didReceiveError(api: self, error: ApiError.dataEncodingFailure(type: type(of: jsonString)))
			return
		}

		var request = URLRequest(url: newGameURL)
		request.httpMethod = "POST"
		request.httpBody = data
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")

		let task = URLSession.shared.dataTask(with: request) { [weak self, weak delegate] _, _, _ in
			guard let self = self, let delegate = delegate else { return }
			delegate.didBeginGame(api: self)
		}
		task.resume()
	}

	private func parseApiResponse(data: Data?, error: Error?, delegate: HiveApiDelegate) {
		if let error = error {
			delegate.didReceiveError(api: self, error: error)
			return
		}

		guard let data = data else {
			delegate.didReceiveError(api: self, error: ApiError.noData)
			return
		}

		do {
			let decoder = JSONDecoder()
			let reply = try decoder.decode(Movement.self, from: data)
			delegate.didPlay(api: self, move: reply)
		} catch {
			delegate.didReceiveError(api: self, error: error)
		}
	}
}

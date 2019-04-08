//
//  HiveAPI.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-02-27.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import HiveEngine

/// Common API errors
enum APIError: Error {
	/// No data was received from the API in response to a request
	case noData
	/// The data from the API failed to be encoded to `type`
	case dataEncodingFailure(type: Any.Type)
}

extension APIError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .noData: return "No data was received from the server."
		case .dataEncodingFailure(let type): return "Value '\(type)' could not be converted to data."
		}
	}
}

protocol HiveAPIDelegate: class {
	func didPlay(api: HiveAPI, move: Movement)
	func didBeginGame(api: HiveAPI)
	func didReceiveError(api: HiveAPI, error: Error)
}

class HiveAPI: Codable {

	/// Name of the API
	let name: String
	/// Description of the API
	let description: String
	/// Name of the asset the API uses
	let iconName: String
	/// Base endpoint for making requests to the API
	let endpoint: String

	var icon: UIImage {
		return UIImage(named: iconName)!
	}

	/// Base URL for making requests to the API
	var endpointURL: URL {
		return URL(string: endpoint)!
	}

	/// URL to provide the player's move and request a `Movement` in response from the API
	var playURL: URL {
		return endpointURL.appendingPathComponent("play")
	}

	/// URL to indicate to the API that a new game is beginning
	var newGameURL: URL {
		return endpointURL.appendingPathComponent("new")
	}

	/// URL to indicate to the API that the current game has ended
	var endGameURL: URL {
		return endpointURL.appendingPathComponent("close")
	}

	/// Post a movement to the API and wait for a movement in response.
	///
	/// - Parameters:
	///   - move: valid movement in the current state
	///   - delegate: callback delegate for response
	func play(_ move: Movement?, delegate: HiveAPIDelegate) {
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
			self.parseAPIResponse(data: data, error: error, delegate: delegate)
		}
		task.resume()
	}

	/// Post a new game command to the API.
	///
	/// - Parameters:
	///   - playerIsFirst: true if the player will move first, false if the API should move first
	///   - delegate: callback delegate for response
	func newGame(playerIsFirst: Bool, delegate: HiveAPIDelegate) {
		let jsonString = "{\"playerIsFirst\": \(playerIsFirst)}"
		guard let data = jsonString.data(using: .utf8) else {
			delegate.didReceiveError(api: self, error: APIError.dataEncodingFailure(type: type(of: jsonString)))
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

	/// Post an end game command to the API.
	func endGame() {
		var request = URLRequest(url: endGameURL)
		request.httpMethod = "POST"

		let task = URLSession.shared.dataTask(with: request) { _, _, _ in }
		task.resume()
	}

	private func parseAPIResponse(data: Data?, error: Error?, delegate: HiveAPIDelegate) {
		if let error = error {
			delegate.didReceiveError(api: self, error: error)
			return
		}

		guard let data = data else {
			delegate.didReceiveError(api: self, error: APIError.noData)
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

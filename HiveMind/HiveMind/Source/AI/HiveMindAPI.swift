//
//  HiveMindAPI.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-14.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

struct HiveMindAPI {

	static func play(state: GameState, completion: (@escaping (Movement?, Error?) -> Void)) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
			playHelper(state: state, completion: completion)
		}
	}

	private static func playHelper(state: GameState, completion: (@escaping (Movement?, Error?) -> Void)) {
		let url = URL(string: "http://ec2-54-205-228-85.compute-1.amazonaws.com:3000/hivemind/play")!

		//create the session object
		let session = URLSession.shared

		//now create the Request object using the url object
		var request = URLRequest(url: url)
		request.httpMethod = "POST" //set http method as POST

		let encoder = JSONEncoder()
		do {
			let data = try encoder.encode(state)
			request.httpBody = data
		} catch {
			completion(nil, error)
			return
		}

		//HTTP Headers
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		//		request.addValue("application/json", forHTTPHeaderField: "Accept")

		//create dataTask using the session object to send data to the server
		let task = session.dataTask(with: request, completionHandler: { data, _, error in

			guard error == nil else {
				completion(nil, error)
				return
			}

			guard let data = data else {
				completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
				return
			}

			print(String.init(data: data, encoding: .utf8)!)

			do {
				//create json object from data
				let decoder = JSONDecoder()
				let reply = try decoder.decode(Movement.self, from: data)
				completion(reply, nil)
			} catch let error {
				print(error.localizedDescription)
				completion(nil, error)
			}
		})

		task.resume()
	}
}

//
//  AIListView.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-06-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import SwiftUI

struct AIListView: View {
	@ObjectBinding var viewModel: AIListViewModel

	var body: some View {
		NavigationView {
			List(viewModel.ais.identified(by: \.name)) { ai in
				AIView(ai: ai)
			}
			.foregroundColor(.red)
			.navigationBarTitle(Text("Hive AIs"))
		}
		.background(Color.background)
	}
}

#if DEBUG
struct AIListView_Preview: PreviewProvider {
	static var previews: some View {
		let ais: [HiveAI] = [
			HiveAI(
				name: "HiveMind",
				description: "This is the HiveMind",
				iconName: "HiveMind/Easy",
				endpoint: "https://www.example.com"
			),
			HiveAI(
				name: "Queen Bee",
				description: "This is the Queen Bee",
				iconName: "HiveMind/Medium",
				endpoint: "https://www.example.com"
			)
		]

		return AIListView(viewModel: AIListViewModel(ais: ais))
	}
}
#endif

//
//  AIView.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-06-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import SwiftUI

struct AIView: View {
	@State var ai: HiveAI
	
	var body: some View {
		return HStack(alignment: .top) {
			Image(uiImage: ai.icon)
				.resizable()
				.frame(width: .icon, height: .icon, alignment: .topLeading)
				.aspectRatio(contentMode: .fill)
				.padding(.smallerSpacing)

			VStack(alignment: .leading) {
				Text(ai.name)
					.modifier(BodyText())
				Text(ai.description)
					.modifier(CaptionText())
			}
			.padding(EdgeInsets(top: .smallerSpacing, leading: 0, bottom: 0, trailing: 0))

			Spacer()
		}
		.background(Color.background)
	}
}

#if DEBUG
struct AIView_Preview: PreviewProvider {
	static var previews: some View {
		AIView(ai: HiveAI(
			name: "HiveMind",
			description: "This is the HiveMind",
			iconName: "HiveMind/Easy",
			endpoint: "https://www.example.com"
		))
	}
}
#endif

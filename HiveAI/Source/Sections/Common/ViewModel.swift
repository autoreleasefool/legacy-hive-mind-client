//
//  ViewModel.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-06-15.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import SwiftUI

protocol ViewModel: BindableObject {
	func handleAction(_ action: ViewAction)
}

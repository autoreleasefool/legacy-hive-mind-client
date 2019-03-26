//
//  RootViewController.swift
//  HiveAI
//
//  Created by Joseph Roque on 2019-03-25.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

class RootViewController: UINavigationController {

	override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	override public init(rootViewController: UIViewController) {
		super.init(rootViewController: rootViewController)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override public var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}

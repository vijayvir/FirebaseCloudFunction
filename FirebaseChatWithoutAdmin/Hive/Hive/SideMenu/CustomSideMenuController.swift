//
//  CustomSideMenuController.swift
//  Example
//
//  Created by Teodor Patras on 16/06/16.
//  Copyright © 2016 teodorpatras. All rights reserved.
//

import Foundation
import SideMenuController

class CustomSideMenuController: SideMenuController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isStatusBarHidden = true
        performSegue(withIdentifier: "showCenterController0", sender: nil)
       // performSegue(withIdentifier: "showCenterController2", sender: nil)
        performSegue(withIdentifier: "containSideMenu", sender: nil)
    }
}

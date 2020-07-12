//
//  ViewController.swift
//  Sample
//
//  Created by Ricardo P Santos on 23/06/2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
//
import RJPSLib_Base
import RJPSLib_Storage
import RJPSLib_Networking

protocol GenericPresenter_Protocol {
    var genericView: GenericView { get }
    func view_deinit()
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
}

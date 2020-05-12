//
//  AppDelegate.swift
//  RJSLib.Sample
//
//  Created by Ricardo P Santos on 23/06/2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import SwiftUI
import RJPSLib

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window?.rootViewController = V.SampleUITestingA_View()
        //self.window?.rootViewController = UIHostingController(rootView: V.SampleA_SwiftUITesting())
        //self.window?.rootViewController = UIHostingController(rootView: V.SampleB_SwiftUITesting())
        print(RJSLib.version)
        return true
    }
}

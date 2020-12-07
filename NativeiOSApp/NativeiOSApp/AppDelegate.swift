//
//  AppDelegate.swift
//  NativeiOSApp
//
//  Created by Konstantin Khokhlov on 07.12.2020.
//  Copyright © 2020 unity. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UnityManager.setHostMainWindow(window)
        UnityManager.setLaunchinOptions(launchOptions)
        return true
    }
}
